function Serialize-DefinitionObject {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [hashtable]$DefinitionObject
    )
    begin {
    }process {
        try {
            $SerializedObject = $DefinitionObject.Clone()
            # Serialize properties with appropriate object values for use by scheduledtasks cmdlets
            if ($DefinitionObject['Trigger']) {
                $SerializedObject['Trigger'] = @(
                    $DefinitionObject['Trigger'] | % {
                        $trigger = $_
                        $triggerTemp = @{}
                        $trigger.GetEnumerator() | % {
                            if ($_.Key -eq 'At') {
                                $d = $_.Value
                                $triggerTemp[$_.Key] = Get-Date @d
                            }elseif ($_.Key -eq 'RepetitionDuration') {
                                $t = $_.Value
                                $triggerTemp[$_.Key] = New-Timespan @t
                            }elseif ($_.Key -eq 'RepetitionInterval') {
                                $t = $_.Value
                                $triggerTemp[$_.Key] = New-Timespan @t
                            }else {
                                $triggerTemp[$_.Key] = $_.Value
                            }
                        }
                        $triggerTemp
                    }
                )
           }
        }catch {
            throw
        }
        $SerializedObject
    }
}
