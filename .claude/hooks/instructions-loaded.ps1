[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

try {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
    $inputObject = $raw | ConvertFrom-Json -Depth 50
} catch {
    exit 0
}

$runtimeDirectory = Join-Path $PSScriptRoot '..\runtime'
New-Item -ItemType Directory -Path $runtimeDirectory -Force | Out-Null

$record = [ordered]@{
    timestampUtc = [DateTime]::UtcNow.ToString('o')
    event = 'InstructionsLoaded'
    cwd = [string]($inputObject.cwd ?? '')
    source = [string]($inputObject.source ?? '')
    filePath = [string]($inputObject.file_path ?? '')
    reason = [string]($inputObject.reason ?? '')
}

$record | ConvertTo-Json -Compress |
    Add-Content -LiteralPath (Join-Path $runtimeDirectory 'instructions-loaded.jsonl') -Encoding UTF8

Write-Output '{}'
exit 0
