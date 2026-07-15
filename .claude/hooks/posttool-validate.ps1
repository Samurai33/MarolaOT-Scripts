[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

try {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
    $inputObject = $raw | ConvertFrom-Json -Depth 50
} catch {
    Write-Warning "PostToolUse validation skipped: invalid JSON input."
    exit 0
}

$filePath = [string]($inputObject.tool_input.file_path ?? '')
if ([string]::IsNullOrWhiteSpace($filePath) -or -not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
    exit 0
}

$extension = [IO.Path]::GetExtension($filePath).ToLowerInvariant()

try {
    switch ($extension) {
        '.json' {
            Get-Content -LiteralPath $filePath -Raw -Encoding UTF8 |
                ConvertFrom-Json -Depth 100 | Out-Null
            Write-Output "Validated JSON: $filePath"
        }
        '.ps1' {
            $tokens = $null
            $errors = $null
            [Management.Automation.Language.Parser]::ParseFile(
                (Resolve-Path -LiteralPath $filePath).Path,
                [ref]$tokens,
                [ref]$errors
            ) | Out-Null
            if ($errors.Count -gt 0) {
                throw ($errors | ForEach-Object Message) -join '; '
            }
            Write-Output "Parsed PowerShell: $filePath"
        }
        '.md' {
            $text = Get-Content -LiteralPath $filePath -Raw -Encoding UTF8
            if ([string]::IsNullOrWhiteSpace($text)) {
                throw 'Markdown file is empty.'
            }
            Write-Output "Checked Markdown: $filePath"
        }
    }
} catch {
    Write-Error "Validation failed for '$filePath': $($_.Exception.Message)"
    exit 1
}

exit 0
