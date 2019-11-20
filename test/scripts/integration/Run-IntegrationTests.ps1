[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'
$VerbosePreference = 'Continue'

$failedCount = 0

$functionTestScriptBlock = {
    try {
        "Command: $script:cmd" | Write-Verbose
        "Args:" | Write-Verbose
        $script:cmdArgs | Out-String -Stream | % { $_.Trim() } | ? { $_ } | Write-Verbose
        for ($i=0; $i -le $iterations-1; $i++) {
            "Iteration: $($i+1)" | Write-Host
            $stdout = & $script:cmd @cmdArgs
            $stdout | Out-String -Stream | % { $_.Trim() } | ? { $_ } | Write-Verbose
        }
    }catch {
        $_ | Write-Error
        $script:failedCount++
    }
}

# Function: Setup-ScheduledTask
$cmd = "Setup-ScheduledTask"
$iterations = 1

$cmdArgs = @{
    DefinitionFile = "$PSScriptRoot\..\..\tasks\tasks.ps1"
}
& $functionTestScriptBlock

$cmdArgs = @{
    DefinitionFile = "$PSScriptRoot\..\..\tasks\tasks.json"
    AsJson = $true
}
& $functionTestScriptBlock

$cmdArgs = @{
    DefinitionDirectory = "$PSScriptRoot\..\..\tasks\"
}
& $functionTestScriptBlock

$cmdArgs = @{
    DefinitionDirectory = "$PSScriptRoot\..\..\tasks\"
    AsJson = $true
}
& $functionTestScriptBlock

$cmdArgs = @{
    DefinitionObject = . "$PSScriptRoot\..\..\tasks\tasks.ps1"
}
& $functionTestScriptBlock


###########
# Results #
###########
if ($failedCount -gt 0) {
    "$failedCount tests failed." | Write-Warning
}
$failedCount
