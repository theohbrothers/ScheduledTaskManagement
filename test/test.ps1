[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$global:PesterDebugPreference_ShowFullErrors = $true

try {
    Push-Location $PSScriptRoot

    # Install test dependencies
    "Installing test dependencies" | Write-Host
    & "$PSScriptRoot\scripts\dep\Install-TestDependencies.ps1" > $null

    # Run unit tests
    "Running unit tests" | Write-Host
    $testFailed = $false
    $res = Invoke-Pester -Script "$PSScriptRoot\..\src\ScheduledTaskManagement" -Tag 'Unit' -PassThru
    if ($res.FailedCount -gt 0) {
        "$( $res.FailedCount ) unit tests failed." | Write-Host
    }

    # Run integration tests
    "Running integration tests" | Write-Host
    $res2 = Invoke-Pester -Script "$PSScriptRoot\..\src\ScheduledTaskManagement" -Tag 'Integration' -PassThru
    if ($res2.FailedCount -gt 0) {
        "$( $res2.FailedCount ) integration tests failed." | Write-Host
    }

    "Listing test artifacts" | Write-Host
    git ls-files --others --exclude-standard

    if (($res -and $res.FailedCount -gt 0) -or ($res2 -and $res2.FailedCount)) {
        throw
    }
}catch {
    throw
}finally {
    Pop-Location
}
