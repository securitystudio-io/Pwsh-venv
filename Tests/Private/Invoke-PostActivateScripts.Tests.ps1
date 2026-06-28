BeforeAll {
    . "$PSScriptRoot\..\..\Private\Invoke-PostActivateScripts.ps1"
}

Describe 'Invoke-PostActivateScripts' {
    Context 'when scripts array is null or empty' {
        It 'does not throw when Scripts is $null' {
            { Invoke-PostActivateScripts -Scripts $null } | Should -Not -Throw
        }

        It 'does not throw when Scripts is an empty array' {
            { Invoke-PostActivateScripts -Scripts @() } | Should -Not -Throw
        }
    }

    Context 'when scripts exist' {
        It 'dot-sources each script in order' {
            $script1 = Join-Path $TestDrive 'first.ps1'
            $script2 = Join-Path $TestDrive 'second.ps1'
            '$global:PwshvenvTestOrder += "first"'  | Set-Content -LiteralPath $script1 -Encoding UTF8
            '$global:PwshvenvTestOrder += "second"' | Set-Content -LiteralPath $script2 -Encoding UTF8

            $global:PwshvenvTestOrder = @()
            Invoke-PostActivateScripts -Scripts @($script1, $script2)
            $global:PwshvenvTestOrder | Should -Be @('first', 'second')
            Remove-Variable -Name PwshvenvTestOrder -Scope Global -ErrorAction SilentlyContinue
        }
    }

    Context 'when a script path does not exist' {
        It 'emits a warning and continues without throwing' {
            $realScript = Join-Path $TestDrive 'real.ps1'
            '$global:PwshvenvRealRan = $true' | Set-Content -LiteralPath $realScript -Encoding UTF8

            $global:PwshvenvRealRan = $false
            { Invoke-PostActivateScripts -Scripts @('C:\does-not-exist.ps1', $realScript) } |
                Should -Not -Throw
            $global:PwshvenvRealRan | Should -BeTrue
            Remove-Variable -Name PwshvenvRealRan -Scope Global -ErrorAction SilentlyContinue
        }
    }
}
