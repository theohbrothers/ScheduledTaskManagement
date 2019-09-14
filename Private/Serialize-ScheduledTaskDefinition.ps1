function Serialize-ScheduledTaskDefinition {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [hashtable]$DefinitionObject
    )
    begin {
        $SerializedObject = $DefinitionObject | New-Clone
    }process {
        try {
            # Serialize proerties with appropriate object values for use by scheduledtasks cmdlets
            if ($DefinitionObject['Triggers']) {
                $DefinitionObject['Triggers'].GetEnumerator() | % {
                   if ($_.Key -eq 'At') {
                        $d = $_.Value
                        $SerializedObject['Triggers'][$_.Key] = Get-Date @d
                   }elseif ($_.Key -eq 'RepetitionInterval') {
                        $t = $_.Value
                        $SerializedObject['Triggers'][$_.Key] = New-Timespan @t
                   }
               }
           }
        }catch {
            throw
        }
        $SerializedObject
    }
}
