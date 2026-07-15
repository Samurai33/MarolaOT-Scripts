[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

try {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
    $inputObject = $raw | ConvertFrom-Json -Depth 50
} catch {
    Write-Error "Claude hook input is not valid JSON: $($_.Exception.Message)"
    exit 2
}

$toolName = [string]$inputObject.tool_name
$toolInput = $inputObject.tool_input
$command = [string]($toolInput.command ?? '')
$filePath = [string]($toolInput.file_path ?? $toolInput.path ?? '')

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
