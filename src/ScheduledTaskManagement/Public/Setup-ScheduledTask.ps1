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
                        # If multiple .json files are found, the resulting collection on PS 5.1 is a collection of the arrays of objects within each .json file's content rather than the objects themselves.
                        # This results in a situation, where when looping over objects within $DefinitionsCollection, only the last object within each array is processed in the pipeline, leading to the serialization and creation / application of only those tasks.
                        # This behavior appears related to a limitation of `ConvertFrom-Json` prior to PS 6.0: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertfrom-json?view=powershell-7.2#parameters and does not seem to affect parallel CI jobs on PS 7.2.6 .
                        # To ensure all objects are processed, return each object within the .json array object regardless of PS version.
                        # Missing tasks: https://dev.azure.com/theohbrothers/ScheduledTaskManagement/_build/results?buildId=437&view=logs&j=a4c7e33e-604c-560c-49b1-4d6828efc661&t=3de151fa-1c49-59eb-ac4b-c29a43df6985
                        # Missing and incorrect objects: https://dev.azure.com/theohbrothers/ScheduledTaskManagement/_build/results?buildId=448&view=logs&j=a4c7e33e-604c-560c-49b1-4d6828efc661&t=3de151fa-1c49-59eb-ac4b-c29a43df6985
                        # Expected objects and tasks: https://dev.azure.com/theohbrothers/ScheduledTaskManagement/_build/results?buildId=450&view=logs&j=a4c7e33e-604c-560c-49b1-4d6828efc661&t=3de151fa-1c49-59eb-ac4b-c29a43df6985
                        Get-Content $_.FullName | ConvertFrom-Json | % { $_ }
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
