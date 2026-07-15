@{
    Severity = @(
        'Error'
        'Warning'
    )

    ExcludeRules = @(
        # Interactive maintenance scripts intentionally display colored status
        # output. Write-Host is supported by the minimum PowerShell 5.1 target.
        'PSAvoidUsingWriteHost'

        # Repository text files are normalized as UTF-8 without BOM to preserve
        # compatibility with OTClient/vBot loaders and cross-platform tooling.
        'PSUseBOMForUnicodeEncodedFile'

        # Private helper functions execute only inside scripts whose public entry
        # point already implements SupportsShouldProcess and transactional backup.
        'PSUseShouldProcessForStateChangingFunctions'

        # Some parameters are consumed by nested helper functions through the
        # script scope; PSScriptAnalyzer cannot resolve those closure references.
        'PSReviewUnusedParameter'
    )
}
