function Invoke-PostActivateScripts {
    <#
    .SYNOPSIS
        Dot-sources each script listed in a profile's postActivateScripts array.
    .DESCRIPTION
        Iterates the provided list of script paths and dot-sources each one in the caller's
        scope so that variables and functions they define become available in the session.
        Missing or empty arrays are silently skipped. Non-existent script paths emit a warning
        rather than terminating, so a broken entry does not prevent the remaining scripts
        from running.
    .PARAMETER Scripts
        Array of absolute paths to PowerShell scripts (.ps1) to dot-source. May be $null or empty.
    .EXAMPLE
        Invoke-PostActivateScripts -Scripts $profile.PostActivateScripts
    .NOTES
        Used internally by Enter-Pwshvenv.
    #>
    [CmdletBinding()]
    param(
        [string[]] $Scripts
    )

    if (-not $Scripts -or $Scripts.Count -eq 0) {
        return
    }

    foreach ($script in $Scripts) {
        if (-not (Test-Path -LiteralPath $script -PathType Leaf)) {
            Write-Warning "Post-activate script not found, skipping: $script"
            continue
        }
        Write-Verbose "Running post-activate script: $script"
        . $script
    }
}
