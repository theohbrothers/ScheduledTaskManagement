function Setup-ScheduledTask {
    [CmdletBinding(DefaultParameterSetName='DefinitionFile')]
    Param(
        [Parameter(ParameterSetName='DefinitionFile',ValueFromPipeline,Mandatory=$true)]
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [ValidateNotNullOrEmpty()]
        [string[]]$DefinitionFile
    ,
        [Parameter(ParameterSetName='DefinitionPath',ValueFromPipeline,Mandatory=$true)]
        [ValidateScript({Test-Path $_ -PathType Container})]
        [ValidateNotNullOrEmpty()]
        [string[]]$DefinitionDirectory
    ,
        [Parameter(ParameterSetName='AsJson',Mandatory=$false)]
        [Parameter(ParameterSetName='DefinitionFile')]
        [Parameter(ParameterSetName='DefinitionPath')]
        [switch]$AsJson
    )
    try {
        # Import definitions as an array of hashtable definitions
        $DefinitionsCollection = New-Object System.Collections.ArrayList
        if ($DefinitionFile) {
            $DefinitionFileCollection = Get-Item $DefinitionFile
        }elseif ($DefinitionDirectory) {
            $DefinitionFileCollection = if ($AsJson) {
                                            Get-ChildItem $DefinitionDirectory -File | ? { $_.Extension -eq '.json' }
                                        }else {
                                            Get-ChildItem $DefinitionDirectory -File | ? { $_.Extension -eq '.ps1' }
                                        }
        }
        $DefinitionFileCollection | % {
            $definition = if ($AsJson) {
                                Get-Content -Path $_.FullName | ConvertFrom-Json | ConvertTo-Hashtable
                          }else {
                              . $_.FullName
                          }
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
