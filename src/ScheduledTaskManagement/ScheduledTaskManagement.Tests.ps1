Describe "ScheduledTaskManagement" -Tag 'Integration' {
    BeforeAll {
        $ErrorView = 'NormalView'
    }
    BeforeEach {
    }
    AfterEach {
        $script:stdout | Out-String -Stream | % { $_.Trim() } | ? { $_ } | Write-Host
    }
    It "Runs Setup-ScheduledTask -DefinitionFile" {
        $script:stdout = Setup-ScheduledTask -DefinitionFile "definitions\scheduledtasks\tasks-1.ps1" -ErrorAction Stop
    }
    It "Runs Setup-ScheduledTask -DefinitionFile -AsJson" {
        $script:stdout = Setup-ScheduledTask -DefinitionFile "definitions\scheduledtasks\tasks-1.json" -AsJson -ErrorAction Stop
    }
    It "Runs Setup-ScheduledTask -DefinitionDirectory" {
        $script:stdout = Setup-ScheduledTask -DefinitionDirectory "definitions\scheduledtasks\" -ErrorAction Stop
    }
    It "Runs Setup-ScheduledTask -DefinitionDirectory -AsJson" {
        $script:stdout = Setup-ScheduledTask -DefinitionDirectory "definitions\scheduledtasks\" -AsJson -ErrorAction Stop
    }
    It "Runs Setup-ScheduledTask -DefinitionObject" {
        $tasks = . ".\definitions\scheduledtasks\tasks-1.ps1"
        $script:stdout = Setup-ScheduledTask -DefinitionObject $tasks -ErrorAction Stop
    }
    It "Runs `$tasks | Setup-ScheduledTask from .ps1 definition file" {
        $tasks = . ".\definitions\scheduledtasks\tasks-1.ps1"
        $script:stdout = $tasks | Setup-ScheduledTask -ErrorAction Stop
    }
    It "Runs `$tasks | Setup-ScheduledTask from .json definition file" {
        $tasks = Get-Content "definitions\scheduledtasks\tasks-1.json" | ConvertFrom-Json | % { $_ }
        $script:stdout = $tasks | Setup-ScheduledTask -ErrorAction Stop
    }
    It "Runs `$tasks | Setup-ScheduledTask from directory containing .ps1 definition file(s)" {
        $tasks = Get-ChildItem "definitions\scheduledtasks\" -File | ? { $_.Extension -eq '.ps1' } | % { . $_.FullName }
        $script:stdout = $tasks | Setup-ScheduledTask -ErrorAction Stop
    }
    It "Runs `$tasks | Setup-ScheduledTask from directory containing .json definition file(s)" {
        $tasks = Get-ChildItem "definitions\scheduledtasks\" -File | ? { $_.Extension -eq '.json' } | % { Get-Content $_.FullName | ConvertFrom-Json | % { $_ } }
        $script:stdout = $tasks | Setup-ScheduledTask -ErrorAction Stop
    }
}
