function Apply-ScheduledTask {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [hashtable]$DefinitionObject
    )
    begin {
        try {
            # Prepare scheduled task args based on definition object
            $triggerArgs = $DefinitionObject['Triggers']
            $actionArgs = $DefinitionObject['Action']
            $settingsArgs = $DefinitionObject['Settings']
            $principalArgs = $DefinitionObject['Principal']
            $scheduledTaskArgs = @{
                TaskName = $DefinitionObject['TaskName']
                TaskPath = $DefinitionObject['TaskPath']
                Trigger = New-ScheduledTaskTrigger @triggerArgs
                Action = New-ScheduledTaskAction @actionArgs
                Settings = New-ScheduledTaskSettingsSet @settingsArgs
                Principal = New-ScheduledTaskPrincipal @principalArgs
            }
        }catch {
            throw
        }
    }process {
        try {
            if (Get-ScheduledTask -TaskPath $DefinitionObject['TaskPath'] -TaskName $DefinitionObject['TaskName'] -ErrorAction SilentlyContinue) {
                Set-ScheduledTask @scheduledTaskArgs
            }else {
                Register-ScheduledTask @scheduledTaskArgs
            }
        }catch {
            throw
        }
    }
}
