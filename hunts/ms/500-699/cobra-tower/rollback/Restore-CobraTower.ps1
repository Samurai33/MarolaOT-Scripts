[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$ProfilePath = "C:\Users\Samurai\AppData\Roaming\marolaot\marolaot\marolaot\bot\vBot_4.8",

    [Parameter()]
    [string]$BackupPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

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

    $json = $serializer.Serialize($Data)
    [System.IO.File]::WriteAllText($Path, $json, $utf8NoBom)
}

Write-Host "`n===== RESTORE COBRA TOWER PACKAGE =====" -ForegroundColor Cyan

if (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match 'MarolaOT|otclient' }) {
    throw 'Close MarolaOT completely before restoring a backup.'
}

$backupRoot = Join-Path $ProfilePath 'marolaot-scripts-backups\cobra-tower'

if ([string]::IsNullOrWhiteSpace($BackupPath)) {
    $latestPointer = Join-Path $backupRoot 'latest-backup.txt'

    if (Test-Path -LiteralPath $latestPointer) {
        $BackupPath = [System.IO.File]::ReadAllText($latestPointer).Trim()
    }
    else {
        $BackupPath = Get-ChildItem -LiteralPath $backupRoot -Directory -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1 |
            ForEach-Object { $_.FullName }
    }
}

if ([string]::IsNullOrWhiteSpace($BackupPath) -or -not (Test-Path -LiteralPath $BackupPath)) {
    throw "No Cobra Tower backup was found under: $backupRoot"
}

$manifestPath = Join-Path $BackupPath 'backup-manifest.json'
if (-not (Test-Path -LiteralPath $manifestPath)) {
    throw "Backup manifest not found: $manifestPath"
}

$manifest = Read-MarolaJson -Path $manifestPath

if ([string]$manifest['package'] -ne 'cobra-tower-max-dps-v2') {
    throw "Unexpected package in backup manifest: $($manifest['package'])"
}

if (-not $PSCmdlet.ShouldProcess($ProfilePath, "Restore Cobra Tower backup '$BackupPath'")) {
    return
}

foreach ($item in @($manifest['items'])) {
    $originalPath = [string]$item['originalPath']
    $existed = [bool]$item['existed']
    $backupFile = [string]$item['backupFile']

    if ($existed) {
        if ([string]::IsNullOrWhiteSpace($backupFile)) {
            throw "Backup file is missing from manifest for: $originalPath"
        }

        $backupFilePath = Join-Path $BackupPath $backupFile
        if (-not (Test-Path -LiteralPath $backupFilePath)) {
            throw "Backup payload not found: $backupFilePath"
        }

        $directory = Split-Path -Parent $originalPath
        if ($directory -and -not (Test-Path -LiteralPath $directory)) {
            New-Item -ItemType Directory -Path $directory -Force | Out-Null
        }

        Copy-Item -LiteralPath $backupFilePath -Destination $originalPath -Force
        Write-Host "Restored: $originalPath" -ForegroundColor Green
    }
    elseif (Test-Path -LiteralPath $originalPath) {
        Remove-Item -LiteralPath $originalPath -Force
        Write-Host "Removed package-created file: $originalPath" -ForegroundColor Yellow
    }
}

$attackPath = Join-Path $ProfilePath 'vBot_configs\profile_1\AttackBot.json'
$healPath = Join-Path $ProfilePath 'vBot_configs\profile_1\HealBot.json'
$storagePath = Join-Path $ProfilePath 'storage\profile_1.json'

if (Test-Path -LiteralPath $attackPath) {
    $attackData = Read-MarolaJson -Path $attackPath
    $attackProfiles = @($attackData['AttackBot'])
    if ($attackProfiles.Count -gt 0) {
        $attackProfiles[0]['enabled'] = $false
        $attackData['AttackBot'] = $attackProfiles
        Write-MarolaJson -Path $attackPath -Data $attackData
    }
}

if (Test-Path -LiteralPath $healPath) {
    $healData = Read-MarolaJson -Path $healPath
    $healProfiles = @($healData['healbot'])
    if ($healProfiles.Count -gt 0) {
        $healProfiles[0]['enabled'] = $false
        $healData['healbot'] = $healProfiles
        Write-MarolaJson -Path $healPath -Data $healData
    }
}

if (Test-Path -LiteralPath $storagePath) {
    $storageData = Read-MarolaJson -Path $storagePath
    if ($null -ne $storageData['_configs']) {
        if ($null -ne $storageData['_configs']['cavebot_configs']) {
            $storageData['_configs']['cavebot_configs']['enabled'] = $false
        }

        if ($null -ne $storageData['_configs']['targetbot_configs']) {
            $storageData['_configs']['targetbot_configs']['enabled'] = $false
        }

        Write-MarolaJson -Path $storagePath -Data $storageData
    }
}

$restoreReport = @{
    schemaVersion = '1.0.0'
    package = 'cobra-tower-max-dps-v2'
    restoredAt = (Get-Date).ToString('o')
    backupPath = $BackupPath
    profilePath = $ProfilePath
    modulesForcedOff = $true
}

Write-MarolaJson -Path (Join-Path $BackupPath 'restore-report.json') -Data $restoreReport

Write-Host "`nBackup restored successfully." -ForegroundColor Green
Write-Host 'AttackBot, HealBot, CaveBot and TargetBot were forced OFF after restore.' -ForegroundColor Yellow
