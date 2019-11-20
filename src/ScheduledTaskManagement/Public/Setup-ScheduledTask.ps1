function Setup-ScheduledTask {
    [CmdletBinding(DefaultParameterSetName='DefinitionFile')]
    Param(
        [Parameter(ParameterSetName='DefinitionFile', Mandatory=$true)]
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [ValidateNotNullOrEmpty()]
        [string[]]$DefinitionFile
    ,
        [Parameter(ParameterSetName='DefinitionDirectory', Mandatory=$true)]
        [ValidateScript({Test-Path $_ -PathType Container})]
        [ValidateNotNullOrEmpty()]
        [string[]]$DefinitionDirectory
    ,
        [Parameter(ParameterSetName='DefinitionObject', Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [object[]]$DefinitionObject
    ,
        [Parameter(Mandatory=$false)]
        [Parameter(ParameterSetName='DefinitionFile')]
        [Parameter(ParameterSetName='DefinitionDirectory')]
        [switch]$AsJson
    )
    try {
        # Import definitions as an array of hashtable definitions
        $DefinitionsCollection = New-Object System.Collections.ArrayList
        if ($PSBoundParameters['DefinitionFile']) {
            $DefinitionFileCollection = Get-Item $PSBoundParameters['DefinitionFile']
        }elseif ($PSBoundParameters['DefinitionDirectory']) {
            $DefinitionFileCollection = if ($PSBoundParameters['AsJson']) {
                                            Get-ChildItem $PSBoundParameters['DefinitionDirectory'] -File | ? { $_.Extension -eq '.json' }
                                        }else {
                                            Get-ChildItem $PSBoundParameters['DefinitionDirectory'] -File | ? { $_.Extension -eq '.ps1' }
                                        }
        }
        if (!$PSBoundParameters['DefinitionObject']) {
            if (!$DefinitionFileCollection) {
                "No definitions could be found from the specified definition files or directories." | Write-Error
                return
            }
        }
        if (!$PSBoundParameters['DefinitionObject']) {
            $DefinitionCollectionRaw = $DefinitionFileCollection | % {
                if ($AsJson) {
                    Get-Content -Path $_.FullName | ConvertFrom-Json
                }else {
                    . $_.FullName
                }
            }
        }elseif ($PSBoundParameters['DefinitionObject']) {
            "DefinitionObject" | Write-Verbose
            $DefinitionCollectionRaw = $PSBoundParameters['DefinitionObject']
        }
        $DefinitionCollectionRaw | % {
            $definitionHashtable = if ($_.GetType() -ne [hashtable]) { $_ | ConvertTo-Hashtable } else { $_ }
            $definition = $definitionHashtable | Validate-DefinitionObject
            if ($definition) { $DefinitionsCollection.Add($definition) | Out-Null }
        }

        # Serialize definitions
        $DefinitionsCollectionSerialized = $DefinitionsCollection | % {
            "Serializing task definition:" | Write-Verbose
            $_ | Out-String | Write-Verbose
            try {
                Serialize-DefinitionObject -DefinitionObject $_
            }catch {
                Write-Error -Exception $_.Exception -Message $_.Exception.Message -Category $_.CategoryInfo.Category -TargetObject $_.TargetObject
            }
        }

        # Setup scheduled tasks
        $DefinitionsCollectionSerialized | % {
            "Setting up task:" | Write-Verbose
            $_ | Out-String | Write-Verbose
            try {
                Apply-ScheduledTask -DefinitionObject $_
            }catch {
                Write-Error -Exception $_.Exception -Message $_.Exception.Message -Category $_.CategoryInfo.Category -TargetObject $_.TargetObject
            }
        }
    }catch {
        Write-Error -Exception $_.Exception -Message $_.Exception.Message -Category $_.CategoryInfo.Category -TargetObject $_.TargetObject
    }
}
