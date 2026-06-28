BeforeAll {
    . "$PSScriptRoot\..\..\Private\Resolve-VenvRoot.ps1"
    . "$PSScriptRoot\..\TestHelpers.ps1"
}

Describe 'Resolve-VenvRoot' {
    Context 'when no override is provided' {
        It 'returns $env:USERPROFILE\.venv by default' {
            $expected = Join-Path $env:USERPROFILE '.venv'
            $result   = Resolve-VenvRoot
            $result | Should -Be $expected
        }

        It 'creates the directory if it does not exist' {
            $target = Join-Path $TestDrive 'nonexistent-root'
            Resolve-VenvRoot -VenvRoot $target | Out-Null
            Test-Path -LiteralPath $target -PathType Container | Should -BeTrue
        }
    }

    Context 'when an override path is provided' {
        It 'returns the override path' {
            $override = Join-Path $TestDrive 'custom-root'
            New-Item -ItemType Directory -Path $override -Force | Out-Null
            $result = Resolve-VenvRoot -VenvRoot $override
            $result | Should -Be $override
        }

        It 'creates the override directory if it does not exist' {
            $override = Join-Path $TestDrive 'new-root'
            Resolve-VenvRoot -VenvRoot $override | Out-Null
            Test-Path -LiteralPath $override -PathType Container | Should -BeTrue
        }
    }
}
