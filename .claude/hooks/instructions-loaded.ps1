[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

function Get-PropertyText {
    param(
        [Parameter(Mandatory = $false)]
        [object]$Object,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if ($null -eq $Object) {
        return ''
    }

    $property = $Object.PSObject.Properties[$Name]
    if ($null -eq $property -or $null -eq $property.Value) {
        return ''
    }

    return [string]$property.Value
}

try {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
    $inputObject = $raw | ConvertFrom-Json
} catch {
    exit 0
}

$runtimeDirectory = Join-Path $PSScriptRoot '..\runtime'
New-Item -ItemType Directory -Path $runtimeDirectory -Force | Out-Null

$record = [ordered]@{
    timestampUtc = [DateTime]::UtcNow.ToString('o')
    event = 'InstructionsLoaded'
    cwd = Get-PropertyText -Object $inputObject -Name 'cwd'
    source = Get-PropertyText -Object $inputObject -Name 'source'
    filePath = Get-PropertyText -Object $inputObject -Name 'file_path'
    reason = Get-PropertyText -Object $inputObject -Name 'reason'
}

$record | ConvertTo-Json -Compress |
    Add-Content -LiteralPath (Join-Path $runtimeDirectory 'instructions-loaded.jsonl') -Encoding UTF8

Write-Output '{}'
exit 0
