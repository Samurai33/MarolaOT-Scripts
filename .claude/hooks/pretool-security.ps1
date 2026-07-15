[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

function Get-PropertyText {
    param(
        [Parameter(Mandatory = $false)]
        [object]$Object,

        [Parameter(Mandatory = $true)]
        [string[]]$Names
    )

    if ($null -eq $Object) {
        return ''
    }

    foreach ($name in $Names) {
        $property = $Object.PSObject.Properties[$name]
        if ($null -ne $property -and $null -ne $property.Value) {
            return [string]$property.Value
        }
    }

    return ''
}

try {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
    $inputObject = $raw | ConvertFrom-Json
} catch {
    Write-Error "Claude hook input is not valid JSON: $($_.Exception.Message)"
    exit 2
}

$toolName = Get-PropertyText -Object $inputObject -Names @('tool_name')
$toolInput = $inputObject.tool_input
$command = Get-PropertyText -Object $toolInput -Names @('command')
$filePath = Get-PropertyText -Object $toolInput -Names @('file_path', 'path')

$blockedCommandPatterns = @(
    '(?i)\bgit\s+push\s+(-f|--force|--force-with-lease)\b',
    '(?i)\bgit\s+reset\s+--hard\b',
    '(?i)\bgit\s+clean\s+-(?:[a-z]*f[a-z]*d|[a-z]*d[a-z]*f)\b',
    '(?i)\brm\s+-rf\s+',
    '(?i)\bRemove-Item\b.*\b-Recurse\b.*\b-Force\b',
    '(?i)\bInvoke-Expression\b',
    '(?i)\biex\b.*(?:Invoke-WebRequest|curl|wget)',
    '(?i)(?:curl|wget|Invoke-WebRequest).*(?:\||;|&&)\s*(?:sh|bash|pwsh|powershell|python|node)\b'
)

$blockedPathPatterns = @(
    '(?i)(^|[\\/])\.env(?:\..*)?$',
    '(?i)(^|[\\/])(?:credentials|secrets)\.json$',
    '(?i)(^|[\\/])(?:id_rsa|id_ed25519)$',
    '(?i)\.(?:pem|key)$',
    '(?i)(^|[\\/])\.ssh([\\/]|$)'
)

foreach ($pattern in $blockedCommandPatterns) {
    if ($command -match $pattern) {
        Write-Error "Blocked unsafe command pattern for tool '$toolName'."
        exit 2
    }
}

foreach ($pattern in $blockedPathPatterns) {
    if ($filePath -match $pattern) {
        Write-Error "Blocked access to sensitive path for tool '$toolName': $filePath"
        exit 2
    }
}

Write-Output '{}'
exit 0
