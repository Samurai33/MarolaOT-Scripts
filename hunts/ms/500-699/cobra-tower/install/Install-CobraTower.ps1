[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$ProfilePath = "C:\Users\Samurai\AppData\Roaming\marolaot\marolaot\marolaot\bot\vBot_4.8",

    [Parameter()]
    [ValidateSet('Download', 'Local')]
    [string]$SourceMode = 'Download',

    [Parameter()]
    [string]$SourceCachePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$packageRoot = Split-Path -Parent $PSScriptRoot
$sourceLockPath = Join-Path $packageRoot 'source-lock.json'
$inventoryPath = Join-Path $packageRoot 'inventory.json'
$attackProfilePath = Join-Path $packageRoot 'configs\attack-profile.json'
$healProfilePath = Join-Path $packageRoot 'configs\heal-profile.json'
$suppliesProfilePath = Join-Path $packageRoot 'configs\supplies-profile.json'

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

Add-Type -AssemblyName System.Web.Extensions
$serializer = [System.Web.Script.Serialization.JavaScriptSerializer]::new()
$serializer.MaxJsonLength = [int]::MaxValue
$serializer.RecursionLimit = 500

function Read-MarolaJson {
    param([Parameter(Mandatory)][string]$Path)

    $raw = [System.IO.File]::ReadAllText($Path)
    return $serializer.DeserializeObject($raw)
}

function Write-MarolaJson {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)]$Data
    )

    $directory = Split-Path -Parent $Path
    if ($directory -and -not (Test-Path -LiteralPath $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }

    $json = $serializer.Serialize($Data)
    [System.IO.File]::WriteAllText($Path, $json, $utf8NoBom)
}

function Write-Utf8NoBom {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Content
    )

    $directory = Split-Path -Parent $Path
    if ($directory -and -not (Test-Path -LiteralPath $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }

    [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
}

function Get-GitBlobSha1 {
    param([Parameter(Mandatory)][string]$Path)

    $contentBytes = [System.IO.File]::ReadAllBytes($Path)
    $headerBytes = [System.Text.Encoding]::UTF8.GetBytes("blob $($contentBytes.Length)`0")
    $buffer = [byte[]]::new($headerBytes.Length + $contentBytes.Length)

    [System.Array]::Copy($headerBytes, 0, $buffer, 0, $headerBytes.Length)
    [System.Array]::Copy($contentBytes, 0, $buffer, $headerBytes.Length, $contentBytes.Length)

    $sha1 = [System.Security.Cryptography.SHA1]::Create()
    try {
        $hash = $sha1.ComputeHash($buffer)
    }
    finally {
        $sha1.Dispose()
    }

    return (($hash | ForEach-Object { $_.ToString('x2') }) -join '')
}

function Get-SourceItem {
    param(
        [Parameter(Mandatory)]$SourceLock,
        [Parameter(Mandatory)][string]$Id
    )

    $items = @($SourceLock['files'] | Where-Object { $_['id'] -eq $Id })
    if ($items.Count -ne 1) {
        throw "Source lock must contain exactly one item with id '$Id'."
    }

    return $items[0]
}

function Resolve-SourceFile {
    param(
        [Parameter(Mandatory)]$SourceItem,
        [Parameter(Mandatory)][string]$TempRoot
    )

    $extension = [System.IO.Path]::GetExtension([string]$SourceItem['path'])
    $destination = Join-Path $TempRoot ("{0}{1}" -f $SourceItem['id'], $extension)

    if ($SourceMode -eq 'Local') {
        if ([string]::IsNullOrWhiteSpace($SourceCachePath)) {
            throw 'SourceCachePath is required when SourceMode is Local.'
        }

        $nestedPath = ([string]$SourceItem['path']).Replace('/', '\')
        $candidate = Join-Path $SourceCachePath $nestedPath

        if (-not (Test-Path -LiteralPath $candidate)) {
            $candidate = Join-Path $SourceCachePath (Split-Path $nestedPath -Leaf)
        }

        if (-not (Test-Path -LiteralPath $candidate)) {
            throw "Pinned source file not found in local cache: $($SourceItem['path'])"
        }

        Copy-Item -LiteralPath $candidate -Destination $destination -Force
    }
    else {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest `
            -Uri ([string]$SourceItem['downloadUrl']) `
            -OutFile $destination `
            -UseBasicParsing
    }

    $actualBlob = Get-GitBlobSha1 -Path $destination
    $expectedBlob = ([string]$SourceItem['gitBlobSha1']).ToLowerInvariant()

    if ($actualBlob -ne $expectedBlob) {
        throw "Source integrity check failed for '$($SourceItem['id'])'. Expected Git blob $expectedBlob, got $actualBlob."
    }

    return $destination
}

function New-Backup {
    param(
        [Parameter(Mandatory)][string[]]$Paths,
        [Parameter(Mandatory)][string]$BackupRoot
    )

    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backupPath = Join-Path $BackupRoot $stamp
    New-Item -ItemType Directory -Path $backupPath -Force | Out-Null

    $items = @()
    $index = 0

    foreach ($path in $Paths) {
        $index++
        $exists = Test-Path -LiteralPath $path
        $backupFile = $null

        if ($exists) {
            $backupFile = '{0:D2}-{1}' -f $index, (Split-Path $path -Leaf)
            Copy-Item -LiteralPath $path -Destination (Join-Path $backupPath $backupFile) -Force
        }

        $items += @{
            originalPath = $path
            existed = [bool]$exists
            backupFile = $backupFile
        }
    }

    $manifest = @{
        schemaVersion = '1.0.0'
        package = 'cobra-tower-max-dps-v2'
        createdAt = (Get-Date).ToString('o')
        profilePath = $ProfilePath
        items = $items
    }

    Write-MarolaJson -Path (Join-Path $backupPath 'backup-manifest.json') -Data $manifest
    Write-Utf8NoBom -Path (Join-Path $BackupRoot 'latest-backup.txt') -Content $backupPath

    return $backupPath
}

function Restore-BackupPayload {
    param([Parameter(Mandatory)][string]$BackupPath)

    $manifestPath = Join-Path $BackupPath 'backup-manifest.json'
    if (-not (Test-Path -LiteralPath $manifestPath)) {
        throw "Backup manifest not found during automatic rollback: $manifestPath"
    }

    $manifest = Read-MarolaJson -Path $manifestPath

    foreach ($item in @($manifest['items'])) {
        $originalPath = [string]$item['originalPath']
        $existed = [bool]$item['existed']
        $backupFile = [string]$item['backupFile']

        if ($existed) {
            $backupFilePath = Join-Path $BackupPath $backupFile
            if (-not (Test-Path -LiteralPath $backupFilePath)) {
                throw "Backup payload not found during automatic rollback: $backupFilePath"
            }

            $directory = Split-Path -Parent $originalPath
            if ($directory -and -not (Test-Path -LiteralPath $directory)) {
                New-Item -ItemType Directory -Path $directory -Force | Out-Null
            }

            Copy-Item -LiteralPath $backupFilePath -Destination $originalPath -Force
        }
        elseif (Test-Path -LiteralPath $originalPath) {
            Remove-Item -LiteralPath $originalPath -Force
        }
    }
}

Write-Host "`n===== MAROLAOT COBRA TOWER PACKAGE =====" -ForegroundColor Cyan

if (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match 'MarolaOT|otclient' }) {
    throw 'Close MarolaOT completely before installing the package.'
}

foreach ($packageFile in @(
    $sourceLockPath,
    $inventoryPath,
    $attackProfilePath,
    $healProfilePath,
    $suppliesProfilePath
)) {
    if (-not (Test-Path -LiteralPath $packageFile)) {
        throw "Package file not found: $packageFile"
    }
}

if (-not (Test-Path -LiteralPath $ProfilePath)) {
    throw "vBot profile path not found: $ProfilePath"
}

$paths = @{
    Storage = Join-Path $ProfilePath 'storage\profile_1.json'
    Attack = Join-Path $ProfilePath 'vBot_configs\profile_1\AttackBot.json'
    Heal = Join-Path $ProfilePath 'vBot_configs\profile_1\HealBot.json'
    Supplies = Join-Path $ProfilePath 'vBot_configs\profile_1\Supplies.json'
    Target = Join-Path $ProfilePath 'targetbot_configs\cobra.json'
    Cave = Join-Path $ProfilePath 'cavebot_configs\[550+] Cobra Tower.cfg'
    CaveDryRun = Join-Path $ProfilePath 'cavebot_configs\[550+] Cobra Tower DRY RUN.cfg'
}

foreach ($requiredPath in @($paths.Storage, $paths.Attack, $paths.Heal, $paths.Supplies)) {
    if (-not (Test-Path -LiteralPath $requiredPath)) {
        throw "Required vBot file not found: $requiredPath"
    }
}

if (-not $PSCmdlet.ShouldProcess($ProfilePath, 'Install Cobra Tower MAX DPS v2 package')) {
    return
}

$sourceLock = Read-MarolaJson -Path $sourceLockPath
$attackBundle = Read-MarolaJson -Path $attackProfilePath
$healBundle = Read-MarolaJson -Path $healProfilePath
$suppliesBundle = Read-MarolaJson -Path $suppliesProfilePath

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("marolaot-cobra-{0}" -f ([guid]::NewGuid().ToString('N')))
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null
$backupPath = $null

try {
    Write-Host 'Resolving pinned community references...' -ForegroundColor Yellow

    $caveSource = Resolve-SourceFile `
        -SourceItem (Get-SourceItem -SourceLock $sourceLock -Id 'cavebot') `
        -TempRoot $tempRoot

    $targetSource = Resolve-SourceFile `
        -SourceItem (Get-SourceItem -SourceLock $sourceLock -Id 'targetbot') `
        -TempRoot $tempRoot

    $backupRoot = Join-Path $ProfilePath 'marolaot-scripts-backups\cobra-tower'
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null

    $backupPath = New-Backup `
        -Paths @(
            $paths.Storage,
            $paths.Attack,
            $paths.Heal,
            $paths.Supplies,
            $paths.Target,
            $paths.Cave,
            $paths.CaveDryRun
        ) `
        -BackupRoot $backupRoot

    Write-Host "Backup created: $backupPath" -ForegroundColor Green

    $attackData = Read-MarolaJson -Path $paths.Attack
    $attackProfiles = @($attackData['AttackBot'])
    if ($attackProfiles.Count -ne 5) {
        throw "AttackBot must contain five profiles. Found: $($attackProfiles.Count)"
    }

    $attackProfiles[0] = $attackBundle['profile']
    $attackData['AttackBot'] = $attackProfiles
    $attackData['currentBotProfile'] = 1
    Write-MarolaJson -Path $paths.Attack -Data $attackData

    $healData = Read-MarolaJson -Path $paths.Heal
    $healProfiles = @($healData['healbot'])
    if ($healProfiles.Count -lt 1) {
        throw 'HealBot does not contain profile 1.'
    }

    $healProfiles[0] = $healBundle['profile']
    $healData['healbot'] = $healProfiles
    $healData['currentHealBotProfile'] = 1
    Write-MarolaJson -Path $paths.Heal -Data $healData

    $suppliesData = Read-MarolaJson -Path $paths.Supplies
    if ($null -eq $suppliesData['supplies']) {
        $suppliesData['supplies'] = @{}
    }

    $suppliesName = [string]$suppliesBundle['name']
    $suppliesData['supplies']['currentProfile'] = $suppliesName
    $suppliesData['supplies'][$suppliesName] = $suppliesBundle['profile']
    Write-MarolaJson -Path $paths.Supplies -Data $suppliesData

    $targetData = Read-MarolaJson -Path $targetSource
    foreach ($entry in @($targetData['targeting'])) {
        $name = [string]$entry['name']

        $entry['lureCavebot'] = $true
        $entry['lureCount'] = 6
        $entry['keepDistance'] = $false
        $entry['maxDistance'] = 10
        $entry['dontLoot'] = $true

        if ($name -match 'Vizier') {
            $entry['priority'] = 4
            $entry['danger'] = 4
        }
        elseif ($name -match 'Assassin') {
            $entry['priority'] = 3
            $entry['danger'] = 3
        }
        else {
            $entry['priority'] = 2
            $entry['danger'] = 2
        }
    }

    $targetData['looting'] = @{
        items = @()
        containers = @()
        everyItem = $false
        minCapacity = 0
        maxDanger = 10
    }

    Write-MarolaJson -Path $paths.Target -Data $targetData

    $caveRaw = [System.IO.File]::ReadAllText($caveSource)
    $caveRaw = [regex]::Replace(
        $caveRaw,
        '(?im)^buysupplies:Menkesh\s*,\s*199\s*$',
        'buysupplies:Mehkesh, 199'
    )

    foreach ($marker in @(
        'label:start DP Ank',
        'buysupplies:Mehkesh, 199',
        'buysupplies:Fenech, 199',
        'label:startHunt',
        'supplycheck:startHunt',
        'TargetBot.setOn()',
        'TargetBot.setOff()'
    )) {
        if ($caveRaw -notmatch [regex]::Escape($marker)) {
            throw "Required CaveBot marker not found after adaptation: $marker"
        }
    }

    Write-Utf8NoBom -Path $paths.Cave -Content $caveRaw

    $dryRunRaw = $caveRaw.Replace(
        'TargetBot.setOn()',
        "TargetBot.setOff()`r`nCaveBot.setOff()"
    )

    if ($dryRunRaw -match [regex]::Escape('TargetBot.setOn()')) {
        throw 'Dry-run generation failed: TargetBot.setOn() is still present.'
    }

    Write-Utf8NoBom -Path $paths.CaveDryRun -Content $dryRunRaw

    $storageData = Read-MarolaJson -Path $paths.Storage
    if ($null -eq $storageData['_configs']) {
        $storageData['_configs'] = @{}
    }
    if ($null -eq $storageData['_configs']['cavebot_configs']) {
        $storageData['_configs']['cavebot_configs'] = @{}
    }
    if ($null -eq $storageData['_configs']['targetbot_configs']) {
        $storageData['_configs']['targetbot_configs'] = @{}
    }

    $storageData['_configs']['cavebot_configs']['selected'] = '[550+] Cobra Tower'
    $storageData['_configs']['cavebot_configs']['enabled'] = $false
    $storageData['_configs']['targetbot_configs']['selected'] = 'cobra'
    $storageData['_configs']['targetbot_configs']['enabled'] = $false
    Write-MarolaJson -Path $paths.Storage -Data $storageData

    $attackCheck = Read-MarolaJson -Path $paths.Attack
    $healCheck = Read-MarolaJson -Path $paths.Heal
    $targetCheck = Read-MarolaJson -Path $paths.Target
    $storageCheck = Read-MarolaJson -Path $paths.Storage

    $installedAttack = $attackCheck['AttackBot'][0]
    if ([string]$installedAttack['name'] -ne [string]$attackBundle['name']) {
        throw 'Post-install validation failed: AttackBot profile name mismatch.'
    }
    if (@($installedAttack['attackTable']).Count -ne 6) {
        throw 'Post-install validation failed: expected six attacks.'
    }
    if ([int]$installedAttack['attackTable'][0]['cooldown'] -ne 40500) {
        throw 'Post-install validation failed: Rage of the Skies cooldown mismatch.'
    }
    if ([bool]$installedAttack['enabled']) {
        throw 'Post-install validation failed: AttackBot must remain disabled.'
    }
    if ([bool]$healCheck['healbot'][0]['enabled']) {
        throw 'Post-install validation failed: HealBot must remain disabled.'
    }
    if ([bool]$storageCheck['_configs']['cavebot_configs']['enabled']) {
        throw 'Post-install validation failed: CaveBot must remain disabled.'
    }
    if ([bool]$storageCheck['_configs']['targetbot_configs']['enabled']) {
        throw 'Post-install validation failed: TargetBot must remain disabled.'
    }

    foreach ($entry in @($targetCheck['targeting'])) {
        if (-not [bool]$entry['dontLoot']) {
            throw "Post-install validation failed: internal looting is enabled for $($entry['name'])."
        }
        if ([int]$entry['lureCount'] -ne 6) {
            throw "Post-install validation failed: lureCount mismatch for $($entry['name'])."
        }
    }

    $installedPaths = @(
        $paths.Storage,
        $paths.Attack,
        $paths.Heal,
        $paths.Supplies,
        $paths.Target,
        $paths.Cave,
        $paths.CaveDryRun
    )

    $hashes = @()
    foreach ($installedPath in $installedPaths) {
        $hashes += @{
            path = $installedPath
            sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $installedPath).Hash.ToLowerInvariant()
        }
    }

    $report = @{
        schemaVersion = '1.0.0'
        package = 'cobra-tower-max-dps-v2'
        version = '1.0.0-rc.1'
        installedAt = (Get-Date).ToString('o')
        profilePath = $ProfilePath
        sourceCommit = [string]$sourceLock['source']['commit']
        backupPath = $backupPath
        sourceMode = $SourceMode
        files = $hashes
        modules = @{
            attackBot = $false
            healBot = $false
            caveBot = $false
            targetBot = $false
        }
    }

    Write-MarolaJson -Path (Join-Path $backupPath 'install-report.json') -Data $report

    Write-Host "`nCobra Tower package installed successfully." -ForegroundColor Green
    Write-Host 'AttackBot, HealBot, CaveBot and TargetBot remain OFF.' -ForegroundColor Yellow
    Write-Host "Backup: $backupPath" -ForegroundColor Yellow
    Write-Host 'Select the DRY RUN route for the first controlled route check.' -ForegroundColor Cyan
}
catch {
    $installationError = $_

    if (-not [string]::IsNullOrWhiteSpace([string]$backupPath) -and (Test-Path -LiteralPath $backupPath)) {
        try {
            Restore-BackupPayload -BackupPath $backupPath
            Write-Warning "Installation failed. The previous files were restored from: $backupPath"
        }
        catch {
            Write-Warning "Installation failed and automatic rollback also failed: $($_.Exception.Message)"
            Write-Warning "Manual backup path: $backupPath"
        }
    }

    throw $installationError
}
finally {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}
