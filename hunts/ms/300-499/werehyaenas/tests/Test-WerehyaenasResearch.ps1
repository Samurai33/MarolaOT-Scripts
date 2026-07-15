[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$packageRoot = Split-Path -Parent $PSScriptRoot
$errors = [System.Collections.Generic.List[string]]::new()

function Add-ResearchError {
    param([Parameter(Mandatory)][string]$Message)

    $errors.Add($Message)
}

function Read-JsonDocument {
    param([Parameter(Mandatory)][string]$Path)

    try {
        return Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json
    }
    catch {
        Add-ResearchError "Invalid JSON '$Path': $($_.Exception.Message)"
        return $null
    }
}

$requiredFiles = @(
    'README.md',
    'source-manifest.json',
    'source-lock.json',
    'evidence/monster-data.json',
    'evidence/access-data.json',
    'docs/RESEARCH_REPORT.md',
    'tests/Test-WerehyaenasResearch.ps1'
)

foreach ($relativePath in $requiredFiles) {
    $fullPath = Join-Path $packageRoot ($relativePath.Replace('/', [IO.Path]::DirectorySeparatorChar))
    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        Add-ResearchError "Required research file is missing: $relativePath"
    }
}

$manifest = Read-JsonDocument -Path (Join-Path $packageRoot 'source-manifest.json')
$sourceLock = Read-JsonDocument -Path (Join-Path $packageRoot 'source-lock.json')
$monsterData = Read-JsonDocument -Path (Join-Path $packageRoot 'evidence/monster-data.json')
$accessData = Read-JsonDocument -Path (Join-Path $packageRoot 'evidence/access-data.json')

if ($null -ne $manifest) {
    if ($manifest.maturity -ne 'M2') {
        Add-ResearchError "Werehyaenas must remain M2 during the research-only phase. Found: $($manifest.maturity)"
    }

    if ($manifest.package.status -ne 'reference-audited') {
        Add-ResearchError "Expected package status reference-audited. Found: $($manifest.package.status)"
    }

    if ($manifest.components.cavebot.status -ne 'missing') {
        Add-ResearchError 'CaveBot must remain missing until a complete route is verified.'
    }

    if ($manifest.components.targetbot.status -ne 'referenced') {
        Add-ResearchError 'TargetBot must remain referenced, not redistributed or adapted, while its license is undeclared.'
    }

    if ($manifest.components.rollback.status -ne 'missing') {
        Add-ResearchError 'Rollback must remain missing because no installer exists in M2.'
    }
}

if ($null -ne $sourceLock) {
    $communitySource = @($sourceLock.sources) |
        Where-Object { $_.id -eq 'community-targetbot' } |
        Select-Object -First 1

    if ($null -eq $communitySource) {
        Add-ResearchError 'Community TargetBot source is missing from source-lock.json.'
    }
    else {
        if ($communitySource.commit -ne '52e6baaa1a32448abe88476fca53dcd466d7678e') {
            Add-ResearchError 'Unexpected community source commit.'
        }

        if ($communitySource.redistribution -ne 'reference-only') {
            Add-ResearchError 'Community TargetBot must remain reference-only.'
        }

        if ($communitySource.license.status -ne 'not-declared') {
            Add-ResearchError 'Community source license status must remain not-declared until new evidence is recorded.'
        }

        $targetFile = @($communitySource.files) |
            Where-Object { $_.id -eq 'werehyaenas-targetbot' } |
            Select-Object -First 1

        if ($null -eq $targetFile) {
            Add-ResearchError 'TargetBot source file is missing from source lock.'
        }
        elseif ($targetFile.gitBlobSha1 -ne 'edd0800b2d736adf69972f3d8033d7deaad2539a') {
            Add-ResearchError 'TargetBot Git blob SHA-1 does not match the audited file.'
        }
    }

    if ($sourceLock.routeSearch.status -ne 'completed-no-match') {
        Add-ResearchError 'Route search status must record completed-no-match until a route is verified.'
    }
}

if ($null -ne $monsterData) {
    $monsters = @($monsterData.monsters)
    if ($monsters.Count -ne 2) {
        Add-ResearchError "Expected two audited monsters. Found: $($monsters.Count)"
    }

    $werehyaena = $monsters | Where-Object { $_.name -eq 'Werehyaena' } | Select-Object -First 1
    $shaman = $monsters | Where-Object { $_.name -eq 'Werehyaena Shaman' } | Select-Object -First 1

    if ($null -eq $werehyaena -or [int]$werehyaena.health -ne 2700) {
        Add-ResearchError 'Werehyaena health evidence is missing or unexpected.'
    }
    elseif ([int]$werehyaena.elements.ice -ne -20 -or [int]$werehyaena.elements.fire -ne 50) {
        Add-ResearchError 'Werehyaena element evidence is inconsistent with the audited Canary source.'
    }

    if ($null -eq $shaman -or [int]$shaman.health -ne 2500) {
        Add-ResearchError 'Werehyaena Shaman health evidence is missing or unexpected.'
    }
    elseif ([int]$shaman.elements.ice -ne -20 -or [int]$shaman.elements.fire -ne 25) {
        Add-ResearchError 'Werehyaena Shaman element evidence is inconsistent with the audited Canary source.'
    }
}

if ($null -ne $accessData) {
    if ($accessData.shortcut.storageSymbol -ne 'Storage.Quest.U10_80.GrimvaleQuest.AncientFeudShortcut') {
        Add-ResearchError 'Unexpected Ancient Feud storage symbol.'
    }

    if (@($accessData.shortcut.teleports).Count -ne 4) {
        Add-ResearchError 'Ancient Feud evidence must contain four audited teleport pairs.'
    }

    if ($accessData.scope.automationStatus -ne 'documentation-only') {
        Add-ResearchError 'Access evidence must remain documentation-only in M2.'
    }
}

$forbiddenDirectories = @(
    'cavebot',
    'targetbot',
    'install',
    'rollback',
    'configs'
)

foreach ($directoryName in $forbiddenDirectories) {
    $directoryPath = Join-Path $packageRoot $directoryName
    if (Test-Path -LiteralPath $directoryPath) {
        Add-ResearchError "Forbidden M2 runtime directory exists: $directoryName"
    }
}

$forbiddenExtensions = @('.cfg', '.lua')
$runtimeFiles = Get-ChildItem -LiteralPath $packageRoot -File -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.Extension -in $forbiddenExtensions }

foreach ($runtimeFile in $runtimeFiles) {
    Add-ResearchError "Unexpected executable/reference code file in M2 package: $($runtimeFile.FullName)"
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    throw "Werehyaenas research validation failed with $($errors.Count) error(s)."
}

Write-Output 'Werehyaenas M2 research package validation passed.'
Write-Output "Package root: $packageRoot"
