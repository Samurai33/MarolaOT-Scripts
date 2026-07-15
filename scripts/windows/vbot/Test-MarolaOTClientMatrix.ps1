[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$ProfilePath = "C:\Users\Samurai\AppData\Roaming\marolaot\marolaot\marolaot\bot\vBot_4.8",

    [Parameter()]
    [ValidateScript({ Test-Path -LiteralPath $_ })]
    [string]$ExecutablePath = "C:\Users\Samurai\AppData\Local\Programs\MarolaOT.bak-20260701-032850\MarolaOT.exe",

    [Parameter()]
    [ValidateRange(3, 30)]
    [int]$WindowTimeoutSeconds = 12
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$configDir = Join-Path $ProfilePath 'vBot_configs\profile_1'
$coreFiles = @('AttackBot.json', 'HealBot.json', 'Supplies.json')
$quarantine = Get-ChildItem -LiteralPath $ProfilePath -Directory -Filter 'quarantine-client-crash-*' -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $quarantine) { throw 'Nenhuma quarentena foi encontrada.' }

function Stop-MarolaClient {
    Get-Process -ErrorAction SilentlyContinue |
        Where-Object { $_.ProcessName -match 'MarolaOT|otclient' } |
        Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 500
}

function Clear-CoreConfig {
    foreach ($name in $coreFiles) {
        $active = Join-Path $configDir $name
        if (Test-Path -LiteralPath $active) { Remove-Item -LiteralPath $active -Force }
    }
}

function Set-TestConfig {
    param([string[]]$Names)
    Clear-CoreConfig
    foreach ($name in $Names) {
        Copy-Item -LiteralPath (Join-Path $quarantine.FullName $name) -Destination (Join-Path $configDir $name) -Force
    }
}

function Test-Stage {
    param([string]$Name, [string[]]$Files)

    Stop-MarolaClient
    Set-TestConfig -Names $Files
    $process = Start-Process -FilePath $ExecutablePath -WorkingDirectory (Split-Path $ExecutablePath -Parent) -PassThru
    $state = 'UNKNOWN'
    $windowTitle = ''

    $attempts = $WindowTimeoutSeconds * 2
    foreach ($attempt in 1..$attempts) {
        Start-Sleep -Milliseconds 500
        $running = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match 'MarolaOT|otclient' }
        $window = $running | Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1

        if ($window) {
            $state = 'WINDOW_OPENED'
            $windowTitle = $window.MainWindowTitle
            break
        }

        if ($process.HasExited -and -not $running) {
            $state = 'PROCESS_EXITED'
            break
        }
    }

    [PSCustomObject]@{
        Test        = $Name
        Files       = if ($Files.Count) { $Files -join ', ' } else { 'None' }
        State       = $state
        WindowTitle = $windowTitle
        ExitCode    = if ($process.HasExited) { $process.ExitCode } else { $null }
    }

    Stop-MarolaClient
}

$tests = @(
    @{ Name = 'Safe boot'; Files = @() },
    @{ Name = 'Supplies only'; Files = @('Supplies.json') },
    @{ Name = 'HealBot only'; Files = @('HealBot.json') },
    @{ Name = 'AttackBot only'; Files = @('AttackBot.json') },
    @{ Name = 'All core configs'; Files = @('Supplies.json', 'HealBot.json', 'AttackBot.json') }
)

$results = foreach ($test in $tests) {
    Test-Stage -Name $test.Name -Files $test.Files
}

Stop-MarolaClient
Clear-CoreConfig
$results | Format-Table -AutoSize -Wrap
Write-Host 'Estado final: configurações principais isoladas.' -ForegroundColor Yellow
