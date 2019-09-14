
function Setup-ScheduledTask {
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName='Definition',ValueFromPipeline,Mandatory=$true)]
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [ValidateNotNullOrEmpty()]
        [object]$DefinitionFile
    ,
        [Parameter(ParameterSetName='DefinitionPath',ValueFromPipeline,Mandatory=$true)]
        [ValidateScript({Test-Path $_ -PathType Container})]
        [ValidateNotNullOrEmpty()]
        [object]$DefinitionDirectory
    )
    try {
        # Import definitions as an array of hashtable definitions
        $DefinitionsCollection = New-Object System.Collections.ArrayList
        if ($DefinitionFile) {
            $DefinitionFileCollection = Get-Item $DefinitionFile
        }elseif ($DefinitionDirectory) {
            $DefinitionFileCollection = Get-ChildItem $DefinitionDirectory -File | ? { $_.Extension -eq '.ps1' }
        }
        $DefinitionFileCollection | % {
            $definition = . $_.FullName
            $definition | % {
                $definitionValidated = $_ | Validate-DefinitionObject
                if ($definitionValidated) { $DefinitionsCollection.Add($definitionValidated) | Out-Null }
            }
        }

        # Serialize definitions
        $DefinitionsCollectionSerialized = $DefinitionsCollection | % {
            "Serializing task definition:" | Write-Verbose
            $_ | Out-String | Write-Verbose
            try {
                Serialize-DefinitionObject -DefinitionObject $_
            }catch {
                $_ | Write-Error
            }
        }

        # Setup scheduled tasks
        $DefinitionsCollectionSerialized | % {
            "Setting up task:" | Write-Verbose
            $_ | Out-String | Write-Verbose
            try {
                Apply-ScheduledTask -DefinitionObject $_
            }catch {
                $_ | Write-Error
            }
        }
    }catch {
        throw
    }
}
