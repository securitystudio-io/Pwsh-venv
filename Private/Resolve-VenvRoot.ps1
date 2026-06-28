function Resolve-VenvRoot {
    <#
    .SYNOPSIS
        Returns the effective root directory where venv profiles and environments are stored.
    .DESCRIPTION
        Accepts an optional override path. If none is given, falls back to $env:USERPROFILE\.venv.
        Creates the directory if it does not already exist.
    .PARAMETER VenvRoot
        Optional override path. When omitted, defaults to $env:USERPROFILE\.venv.
    .OUTPUTS
        System.String — the resolved, guaranteed-existing root path.
    .EXAMPLE
        $root = Resolve-VenvRoot
        # Returns "$env:USERPROFILE\.venv", creating it if needed.
    .EXAMPLE
        $root = Resolve-VenvRoot -VenvRoot 'D:\venvs'
        # Returns 'D:\venvs', creating it if needed.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string] $VenvRoot
    )

    $root = if ($VenvRoot) { $VenvRoot } else { Join-Path $env:USERPROFILE '.venv' }

    if (-not (Test-Path -LiteralPath $root -PathType Container)) {
        New-Item -ItemType Directory -Path $root -Force | Out-Null
        Write-Verbose "Created VenvRoot directory: $root"
    }

    return $root
}
