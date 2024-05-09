[CmdletBinding()]
param (
    [string]$Tag = ''
)
$moduleItem = Get-Item "$PSScriptRoot/../src/*/*.psm1"
$MODULE_PATH = $moduleItem.FullName
$MODULE_DIR = $moduleItem.Directory
$MODULE_NAME = $moduleItem.BaseName

Set-StrictMode -Version Latest
$VerbosePreference = 'Continue'
$global:PesterDebugPreference_ShowFullErrors = $true

try {
    Push-Location $PSScriptRoot

    # Install Pester if needed
    "Checking Pester version" | Write-Host
    $pesterMinimumVersion = [version]'4.0.0'
    $pesterMaximumVersion = [version]'4.10.1'
    $pester = Get-Module 'Pester' -ListAvailable -ErrorAction SilentlyContinue
    if ( !$pester -or !($pester.Version | ? { $_ -ge $pesterMinimumVersion -and $_ -le $pesterMaximumVersion }) ) {
        "Installing Pester" | Write-Host
        Install-Module -Name 'Pester' -Repository 'PSGallery' -MinimumVersion $pesterMinimumVersion -MaximumVersion $pesterMaximumVersion -Scope CurrentUser -Force
    }
    $pester = Get-Module Pester -ListAvailable
    $pester | Out-String | Write-Verbose
    $pester | Select-Object -First 1 | Import-Module # Force import to ensure environment uses the correct version of Pester

    # Import the project module
    Import-Module $MODULE_PATH -Force

    if ($Tag) {
        # Run Unit Tests
        $res = Invoke-Pester -Script $MODULE_DIR -Tag $Tag -PassThru -ErrorAction Stop
        if (!($res.PassedCount -eq $res.TotalCount)) {
            "$($res.TotalCount - $res.PassedCount) unit tests failed." | Write-Host
        }
        if (!($res.PassedCount -eq $res.TotalCount)) {
            throw
        }
    }else {
        # Run Unit Tests
        $res = Invoke-Pester -Script $MODULE_DIR -Tag 'Unit' -PassThru -ErrorAction Stop
        if (!($res.PassedCount -eq $res.TotalCount)) {
            "$($res.TotalCount - $res.PassedCount) integration tests failed." | Write-Host
        }

        # Run Integration Tests
        $res2 = Invoke-Pester -Script $MODULE_DIR -Tag 'Integration' -PassThru -ErrorAction Stop
        if (!($res2.PassedCount -eq $res2.TotalCount)) {
            "$($res2.TotalCount - $res2.PassedCount) integration tests failed." | Write-Host
        }

        if (!($res.PassedCount -eq $res.TotalCount) -or !($res2.PassedCount -eq $res2.TotalCount)) {
            throw
        }
    }

}catch {
    throw
}finally {
    "Listing test artifacts" | Write-Host
    git ls-files --others --exclude-standard
    Pop-Location
}
