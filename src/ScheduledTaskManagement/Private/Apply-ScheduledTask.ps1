function Apply-ScheduledTask {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [hashtable]$DefinitionObject
    )
    begin {
        try {
            # Prepare scheduled task args based on definition object
            $scheduledTaskArgs = @{
                TaskName = $DefinitionObject['TaskName']
                TaskPath = $DefinitionObject['TaskPath']
                Trigger = @(
                    $DefinitionObject['Trigger'] | % {
                        $args = $_
                        New-ScheduledTaskTrigger @args
                    }
                )
                Action = @(
                    $DefinitionObject['Action'] | % {
                        $args = $_
                        New-ScheduledTaskAction @args
                    }
                )
                Settings = $(
                    $args = $DefinitionObject['Settings']
                    New-ScheduledTaskSettingsSet @args
                )
                Principal = $(
                    $args = $DefinitionObject['Principal']
                    New-ScheduledTaskPrincipal @args
                )
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
