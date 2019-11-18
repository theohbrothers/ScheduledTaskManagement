[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$VerbosePreference = 'Continue'
$global:PesterDebugPreference_ShowFullErrors = $true

try {
    Push-Location $PSScriptRoot

    # Install test dependencies
    "Installing test dependencies" | Write-Host
    & "$PSScriptRoot\scripts\dep\Install-TestDependencies.ps1" > $null

    # Run unit tests
    "Running unit tests" | Write-Host
    $testFailed = $false
    $unitResult = Invoke-Pester -Script "$PSScriptRoot\..\src\Compile-SourceScript" -PassThru
    if ($unitResult.FailedCount -gt 0) {
        "$($unitResult.FailedCount) tests failed." | Write-Warning
        $testFailed = $true
    }

    # Run integration tests
    "Running integration tests" | Write-Host
    $integratedFailedCount = & "$PSScriptRoot\scripts\integration\Run-IntegrationTests.ps1"
    if ($integratedFailedCount -gt 0) {
        $testFailed = $true
    }

    "Listing test artifacts" | Write-Host
    git ls-files --others --exclude-standard

    "End of tests" | Write-Host
    if ($testFailed) {
        throw "One or more tests failed."
    }
}catch {
    throw
}finally {
    Pop-Location
}
