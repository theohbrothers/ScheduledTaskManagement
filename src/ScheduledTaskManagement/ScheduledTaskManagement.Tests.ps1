Describe "ScheduledTaskManagement" -Tag 'Integration' {
    BeforeAll {
        $ErrorView = 'NormalView'
    }
    BeforeEach {
    }
    AfterEach {
    }
    It "Runs Setup-ScheduledTask -DefinitionFile" {
        Setup-ScheduledTask -DefinitionFile "definitions\scheduledtasks\tasks-1.ps1" -ErrorAction Stop
    }
    It "Runs Setup-ScheduledTask -DefinitionFile -AsJson" {
        Setup-ScheduledTask -DefinitionFile "definitions\scheduledtasks\tasks-1.json" -AsJson -ErrorAction Stop
    }
    It "Runs Setup-ScheduledTask -DefinitionDirectory" {
        Setup-ScheduledTask -DefinitionDirectory "definitions\scheduledtasks\" -ErrorAction Stop
    }
    It "Runs Setup-ScheduledTask -DefinitionDirectory -AsJson" {
        Setup-ScheduledTask -DefinitionDirectory "definitions\scheduledtasks\" -AsJson -ErrorAction Stop
    }
    It "Runs Setup-ScheduledTask -DefinitionObject" {
        $tasks = . ".\definitions\scheduledtasks\tasks-1.ps1"
        Setup-ScheduledTask -DefinitionObject $tasks -ErrorAction Stop
    }
    It "Runs `$tasks | Setup-ScheduledTask from .ps1 definition file" {
        $tasks = . ".\definitions\scheduledtasks\tasks-1.ps1"
        $tasks | Setup-ScheduledTask -ErrorAction Stop
    }
    It "Runs `$tasks | Setup-ScheduledTask from .json definition file" {
        $tasks = Get-Content "definitions\scheduledtasks\tasks-1.json" | ConvertFrom-Json | % { $_ }
        $tasks | Setup-ScheduledTask -ErrorAction Stop
    }
    It "Runs `$tasks | Setup-ScheduledTask from directory containing .ps1 definition file(s)" {
        $tasks = Get-ChildItem "definitions\scheduledtasks\" -File | ? { $_.Extension -eq '.ps1' } | % { . $_.FullName }
        $tasks | Setup-ScheduledTask -ErrorAction Stop
    }
    It "Runs `$tasks | Setup-ScheduledTask from directory containing .json definition file(s)" {
        $tasks = Get-ChildItem "definitions\scheduledtasks\" -File | ? { $_.Extension -eq '.json' } | % { Get-Content $_.FullName | ConvertFrom-Json | % { $_ } }
        $tasks | Setup-ScheduledTask -ErrorAction Stop
    }
}
