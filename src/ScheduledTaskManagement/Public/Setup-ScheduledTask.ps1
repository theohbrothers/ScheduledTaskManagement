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
        [Parameter(ParameterSetName='DefinitionObject', Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [object[]]$DefinitionObject
        ,
        [Parameter(ParameterSetName='DefinitionFile', Mandatory=$false)]
        [Parameter(ParameterSetName='DefinitionDirectory', Mandatory=$false)]
        [switch]$AsJson
    )
    begin {
        try {
            # Import definitions as an array of hashtable definitions (begin)
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
            if ($DefinitionFile -or $DefinitionDirectory) {
                if (!$DefinitionFileCollection) {
                    "No definitions could be found from the specified definition files or directories." | Write-Error
                    return
                }
                $DefinitionCollectionRaw = $DefinitionFileCollection | % {
                    if ($AsJson) {
                        Get-Content $_.FullName | ConvertFrom-Json
                    }else {
                        . $_.FullName
                    }
                }
            }elseif ($DefinitionObject) {   # $DefinitionObject being non-null in the begin block indicates the value was not passed via pipeline
                $isDefinitionObjectValueFromPipeline = $false
            }else {
                $isDefinitionObjectValueFromPipeline = $true
            }
        }catch {
            Write-Error -Exception $_.Exception -Message $_.Exception.Message -Category $_.CategoryInfo.Category -TargetObject $_.TargetObject
        }
    }process {
        try {
            # Import definitions as an array of hashtable definitions (process)
            if ($DefinitionObject) {
                $DefinitionCollectionRaw = $DefinitionObject    # Store the array of objects or present object of $DefinitionObject processed within the pipeline
            }
            $DefinitionCollectionRaw | % {
                $definitionHashtable = if ($_.GetType() -ne [hashtable]) { $_ | ConvertTo-Hashtable } else { $_ }
                $definition = $definitionHashtable | Validate-DefinitionObject
                if ($definition) {
                    if ($DefinitionObject) {
                        if ($isDefinitionObjectValueFromPipeline) {
                            $DefinitionsCollection.Clear()  # Clear the $DefinitionsCollection arraylist to have the variable store only the present object of $DefinitionObject processed within the pipeline
                        }
                    }
                    $DefinitionsCollection.Add($definition) | Out-Null
                }
            }

            # Serialize definitions
            $DefinitionsCollectionSerialized = $DefinitionsCollection | % {
                "Serializing task definition:" | Write-Verbose
                $_ | Out-String -Stream | % { $_.Trim() } | ? { $_ } | Write-Verbose
                try {
                    Serialize-DefinitionObject -DefinitionObject $_
                }catch {
                    Write-Error -Exception $_.Exception -Message $_.Exception.Message -Category $_.CategoryInfo.Category -TargetObject $_.TargetObject
                }
            }

            # Setup scheduled tasks
            $DefinitionsCollectionSerialized | % {
                "Setting up task:" | Write-Verbose
                $_ | Out-String -Stream | % { $_.Trim() } | ? { $_ } | Write-Verbose
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
}
