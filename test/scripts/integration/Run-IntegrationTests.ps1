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
            if ($script:cmdArgs) {
                $stdout = & $script:cmd @script:cmdArgs
            }else {
                $stdout = & $script:cmd
            }
            $stdout | Out-String -Stream | % { $_.Trim() } | ? { $_ } | Write-Host
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
    DefinitionFile = "$PSScriptRoot\..\..\definitions\scheduledtasks\tasks-1.ps1"
}
& $functionTestScriptBlock

$cmdArgs = @{
    DefinitionFile = "$PSScriptRoot\..\..\definitions\scheduledtasks\tasks-1.json"
    AsJson = $true
}
& $functionTestScriptBlock

$cmdArgs = @{
    DefinitionDirectory = "$PSScriptRoot\..\..\definitions\scheduledtasks\"
}
& $functionTestScriptBlock

$cmdArgs = @{
    DefinitionDirectory = "$PSScriptRoot\..\..\definitions\scheduledtasks\"
    AsJson = $true
}
& $functionTestScriptBlock

$cmd = {
    $tasks = . "$PSScriptRoot\..\..\definitions\scheduledtasks\tasks-1.ps1"
    Setup-ScheduledTask -DefinitionObject $tasks
}
$cmdArgs = $null
& $functionTestScriptBlock

$cmd = {
    $tasks = . "$PSScriptRoot\..\..\definitions\scheduledtasks\tasks-1.ps1"
    $tasks | Setup-ScheduledTask
}
$cmdArgs = $null
& $functionTestScriptBlock

$cmd = {
    $tasks = Get-Content "$PSScriptRoot\..\..\definitions\scheduledtasks\tasks-1.json" | ConvertFrom-Json | % { $_ }
    $tasks | Setup-ScheduledTask
}
$cmdArgs = $null
& $functionTestScriptBlock

$cmd = {
    $tasks = Get-ChildItem "$PSScriptRoot\..\..\definitions\scheduledtasks\" -File | ? { $_.Extension -eq '.ps1' } | % { . $_.FullName }
    $tasks | Setup-ScheduledTask
}
$cmdArgs = $null
& $functionTestScriptBlock

$cmd = {
    $tasks = Get-ChildItem "$PSScriptRoot\..\..\definitions\scheduledtasks\" -File | ? { $_.Extension -eq '.json' } | % { Get-Content $_.FullName | ConvertFrom-Json | % { $_ } }
    $tasks | Setup-ScheduledTask
}
$cmdArgs = $null
& $functionTestScriptBlock

###########
# Results #
###########
if ($failedCount -gt 0) {
    "$failedCount tests failed." | Write-Warning
}
$failedCount
