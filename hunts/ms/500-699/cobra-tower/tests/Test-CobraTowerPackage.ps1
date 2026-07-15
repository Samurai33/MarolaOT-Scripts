[CmdletBinding()]
param(
    [Parameter()]
    [switch]$SkipChecksums
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$packageRoot = Split-Path -Parent $PSScriptRoot
$errors = [System.Collections.Generic.List[string]]::new()

function Add-TestError {
    param([Parameter(Mandatory)][string]$Message)
    $errors.Add($Message)
}

function Read-JsonDocument {
    param([Parameter(Mandatory)][string]$Path)

    try {
        return Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json
    }
    catch {
        Add-TestError "Invalid JSON '$Path': $($_.Exception.Message)"
        return $null
    }
}

$requiredFiles = @(
    'README.md',
    'source-manifest.json',
    'source-lock.json',
    'inventory.json',
    'configs/attack-profile.json',
    'configs/heal-profile.json',
    'configs/supplies-profile.json',
    'install/Install-CobraTower.ps1',
    'rollback/Restore-CobraTower.ps1',
    'tests/CHECKLIST.md',
    'docs/UPSTREAM_DIFF.md',
    'checksums.sha256'
)

foreach ($relativePath in $requiredFiles) {
    $fullPath = Join-Path $packageRoot ($relativePath.Replace('/', '\'))
    if (-not (Test-Path -LiteralPath $fullPath)) {
        Add-TestError "Required package file is missing: $relativePath"
    }
}

$sourceLock = Read-JsonDocument -Path (Join-Path $packageRoot 'source-lock.json')
$inventory = Read-JsonDocument -Path (Join-Path $packageRoot 'inventory.json')
$attack = Read-JsonDocument -Path (Join-Path $packageRoot 'configs\attack-profile.json')
$heal = Read-JsonDocument -Path (Join-Path $packageRoot 'configs\heal-profile.json')
$supplies = Read-JsonDocument -Path (Join-Path $packageRoot 'configs\supplies-profile.json')
$manifest = Read-JsonDocument -Path (Join-Path $packageRoot 'source-manifest.json')

if ($null -ne $sourceLock) {
    if ($sourceLock.source.commit -notmatch '^[0-9a-f]{40}$') {
        Add-TestError 'Source lock commit must be a full 40-character SHA.'
    }

    $lockedFiles = @($sourceLock.files)
    if ($lockedFiles.Count -ne 2) {
        Add-TestError "Source lock must contain exactly two files. Found: $($lockedFiles.Count)"
    }

    foreach ($lockedFile in $lockedFiles) {
        if ($lockedFile.gitBlobSha1 -notmatch '^[0-9a-f]{40}$') {
            Add-TestError "Invalid Git blob SHA-1 for source id '$($lockedFile.id)'."
        }
        if ($lockedFile.downloadUrl -notmatch [regex]::Escape($sourceLock.source.commit)) {
            Add-TestError "Download URL for '$($lockedFile.id)' is not pinned to the source commit."
        }
    }

    if ($sourceLock.source.redistribution -ne 'reference-only') {
        Add-TestError 'Community source redistribution must remain reference-only while the license is unconfirmed.'
    }
}

if ($null -ne $attack) {
    if ($attack.name -ne 'Cobra Tower MAX DPS v2') {
        Add-TestError 'Unexpected AttackBot profile name.'
    }

    $attacks = @($attack.profile.attackTable)
    if ($attacks.Count -ne 6) {
        Add-TestError "Attack profile must contain six entries. Found: $($attacks.Count)"
    }
    else {
        $expectedCooldowns = @(40500, 8250, 4250, 2000, 30500, 2000)
        for ($index = 0; $index -lt $expectedCooldowns.Count; $index++) {
            if ([int]$attacks[$index].cooldown -ne $expectedCooldowns[$index]) {
                Add-TestError "Unexpected cooldown at attack index $index."
            }
        }

        if ([int]$attacks[3].itemId -ne 3191) {
            Add-TestError 'GFB must use item id 3191.'
        }
        if ([int]$attacks[5].itemId -ne 3155) {
            Add-TestError 'SD must use item id 3155.'
        }
    }

    if ([bool]$attack.profile.enabled) {
        Add-TestError 'AttackBot profile must be disabled in the package.'
    }
}

if ($null -ne $heal -and [bool]$heal.profile.enabled) {
    Add-TestError 'HealBot profile must be disabled in the package.'
}

if ($null -ne $supplies) {
    foreach ($itemId in @('23373', '3191', '3155')) {
        if ($null -eq $supplies.profile.items.$itemId) {
            Add-TestError "Supplies profile is missing item id $itemId."
        }
    }
}

if ($null -ne $inventory) {
    $installedFiles = @($inventory.installedFiles)
    if ($installedFiles.Count -ne 7) {
        Add-TestError "Inventory must describe seven installed files. Found: $($installedFiles.Count)"
    }
    if (-not [bool]$inventory.modulesOffAfterInstall) {
        Add-TestError 'Inventory must require modules off after installation.'
    }
}

if ($null -ne $manifest) {
    if ($manifest.maturity -ne 'M6') {
        Add-TestError "Package must remain M6 until the release gate is completed. Found: $($manifest.maturity)"
    }
    if ($manifest.package.status -ne 'validated') {
        Add-TestError "Package status must remain validated before M7 release. Found: $($manifest.package.status)"
    }
}

$powerShellFiles = @(
    'install/Install-CobraTower.ps1',
    'rollback/Restore-CobraTower.ps1',
    'tests/Test-CobraTowerPackage.ps1'
)

foreach ($relativePath in $powerShellFiles) {
    $fullPath = Join-Path $packageRoot ($relativePath.Replace('/', '\'))
    if (-not (Test-Path -LiteralPath $fullPath)) {
        continue
    }

    $tokens = $null
    $parseErrors = $null
    [System.Management.Automation.Language.Parser]::ParseFile(
        $fullPath,
        [ref]$tokens,
        [ref]$parseErrors
    ) | Out-Null

    foreach ($parseError in @($parseErrors)) {
        Add-TestError "PowerShell syntax error in '$relativePath': $($parseError.Message)"
    }
}

if (-not $SkipChecksums) {
    $checksumPath = Join-Path $packageRoot 'checksums.sha256'

    if (Test-Path -LiteralPath $checksumPath) {
        $checksumLines = Get-Content -LiteralPath $checksumPath -Encoding UTF8 |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

        foreach ($line in $checksumLines) {
            if ($line -notmatch '^([0-9a-f]{64})  (.+)$') {
                Add-TestError "Invalid checksum line: $line"
                continue
            }

            $expected = $Matches[1]
            $relativePath = $Matches[2]
            $fullPath = Join-Path $packageRoot ($relativePath.Replace('/', '\'))

            if (-not (Test-Path -LiteralPath $fullPath)) {
                Add-TestError "Checksum target is missing: $relativePath"
                continue
            }

            $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $fullPath).Hash.ToLowerInvariant()
            if ($actual -ne $expected) {
                Add-TestError "Checksum mismatch: $relativePath"
            }
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host "`nPACKAGE VALIDATION FAILED" -ForegroundColor Red
    foreach ($testError in $errors) {
        Write-Host " - $testError" -ForegroundColor Red
    }

    throw "Cobra Tower package validation failed with $($errors.Count) error(s)."
}

Write-Host "`nCobra Tower package validation passed." -ForegroundColor Green
Write-Host "Package root: $packageRoot" -ForegroundColor Cyan
