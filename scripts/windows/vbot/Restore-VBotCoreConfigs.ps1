[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$ProfilePath = "C:\Users\Samurai\AppData\Roaming\marolaot\marolaot\marolaot\bot\vBot_4.8",

    [Parameter()]
    [string]$QuarantinePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match 'MarolaOT|otclient' }) {
    throw 'Feche completamente o MarolaOT antes de restaurar arquivos.'
}

$configDir = Join-Path $ProfilePath 'vBot_configs\profile_1'
$coreFiles = @('AttackBot.json', 'HealBot.json', 'Supplies.json')

if (-not $QuarantinePath) {
    $latest = Get-ChildItem -LiteralPath $ProfilePath -Directory -Filter 'quarantine-client-crash-*' -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if (-not $latest) { throw 'Nenhuma quarentena client-crash foi encontrada.' }
    $QuarantinePath = $latest.FullName
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupDir = Join-Path $ProfilePath "backup-before-restore-$stamp"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

foreach ($name in $coreFiles) {
    $source = Join-Path $QuarantinePath $name
    $target = Join-Path $configDir $name

    if (-not (Test-Path -LiteralPath $source)) { throw "Arquivo ausente na quarentena: $source" }
    if (Test-Path -LiteralPath $target) { Copy-Item -LiteralPath $target -Destination (Join-Path $backupDir $name) -Force }

    if ($PSCmdlet.ShouldProcess($target, "Restaurar de $source")) {
        Copy-Item -LiteralPath $source -Destination $target -Force
    }
}

Write-Host "Arquivos restaurados. Backup anterior: $backupDir" -ForegroundColor Green
