function Validate-DefinitionObject {
    Param (
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        $InputObject
    )
    $InputObject | % {
        if ($_.GetType() -ne [hashtable]) {
            Write-Warning "`n$(($InputObject | Out-String).Trim())"
            throw "Object is not a hashtable."
        }
        $_
    }
}
