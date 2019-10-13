# Returns a deep clone of any object
function New-Clone {
    param (
        # Parameter help description
        [Parameter(ValueFromPipeline)]
        [object]$InputObject
    )

    process {
        if ($null -eq $InputObject) {
            return $null
        }

        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            if ($InputObject -is [System.Collections.Specialized.OrderedDictionary]) {
                # It's an ordered dictionary
                $orderedHash = [ordered]@{}
                $InputObject.GetEnumerator() | % {
                    $orderedHash[$_.Name] = New-Clone -InputObject $_.Value
                }
                $orderedHash
            }elseif ( $InputObject -is [hashtable] ) {
                # It's a hashtable
                $hash = [ordered]@{}
                $InputObject.GetEnumerator() | % {
                    $hash[$_.Name] = New-Clone -InputObject $_.Value
                }
                $hash
            }else {
                # It's an array
                $collection = @(
                    foreach ($item in $InputObject) {
                        New-Clone -InputObject $item
                    }
                )
                ,$collection
            }
        }elseif ( $InputObject -isnot [string] -and $InputObject -isnot [int] -and $InputObject -isnot [float] -and $InputObject -isnot [double] -and $InputObject -isnot [bool] ) {
             # It's a pscustomobject with properties and methods
            $InputObject.Copy()
        }else {
            ## If the object isn't an array, collection, or dictionary, hashtable, just return it by value
            $InputObject
        }
    }
}
