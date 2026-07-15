[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$ProfilePath = "C:\Users\Samurai\AppData\Roaming\marolaot\marolaot\marolaot\bot\vBot_4.8"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Web.Extensions
$serializer = [System.Web.Script.Serialization.JavaScriptSerializer]::new()
$serializer.MaxJsonLength = [int]::MaxValue
$serializer.RecursionLimit = 500

$files = @(
    (Join-Path $ProfilePath 'storage\profile_1.json'),
    (Join-Path $ProfilePath 'vBot_configs\profile_1\AttackBot.json'),
    (Join-Path $ProfilePath 'vBot_configs\profile_1\HealBot.json'),
    (Join-Path $ProfilePath 'vBot_configs\profile_1\Supplies.json'),
    (Join-Path $ProfilePath 'targetbot_configs\cobra.json')
)

$results = foreach ($file in $files) {
    try {
        if (-not (Test-Path -LiteralPath $file)) { throw 'Arquivo ausente.' }
        $data = $serializer.DeserializeObject([System.IO.File]::ReadAllText($file))
        [PSCustomObject]@{ File = $file; Valid = $true; Type = $data.GetType().FullName; Error = $null }
    } catch {
        [PSCustomObject]@{ File = $file; Valid = $false; Type = $null; Error = $_.Exception.Message }
    }
}

$results | Format-Table -AutoSize -Wrap

if ($results.Valid -contains $false) {
    throw 'Um ou mais arquivos falharam na validação JSON.'
}

$attackFile = Join-Path $ProfilePath 'vBot_configs\profile_1\AttackBot.json'
$attack = $serializer.DeserializeObject([System.IO.File]::ReadAllText($attackFile))
$profiles = @($attack['AttackBot'])

if ($profiles.Count -ne 5) { throw "AttackBot deve ter 5 perfis; encontrado: $($profiles.Count)" }

$activeIndex = [int]$attack['currentBotProfile'] - 1
$active = $profiles[$activeIndex]

[PSCustomObject]@{
    CurrentProfile = $attack['currentBotProfile']
    Name           = $active['name']
    Enabled        = $active['enabled']
    Rotate         = $active['Rotate']
    PvpSafe        = $active['PvpSafe']
    Visible        = $active['Visible']
    Attacks        = @($active['attackTable']).Count
} | Format-List
