function Validate-DefinitionObject {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [object]$InputObject
    )
    $InputObject | % {
        if ($_.GetType() -ne [hashtable]) {
            Write-Warning "`n$(($InputObject | Out-String).Trim())"
            throw "Object is not a hashtable."
        }
        $_
    }
}
