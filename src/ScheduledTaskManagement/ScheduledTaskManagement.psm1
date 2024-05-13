Set-StrictMode -Version Latest

# Initialize variables
$MODULE_BASE_DIR = $PSScriptRoot
$MODULE_PRIVATE_DIR = Join-Path $MODULE_BASE_DIR 'Private'
$MODULE_PUBLIC_DIR = Join-Path $MODULE_BASE_DIR 'Public'
$MODULE_HELPERS_DIR = Join-Path $MODULE_BASE_DIR 'helpers'

# Load functions
Get-ChildItem "$MODULE_PRIVATE_DIR\*.ps1" -exclude *.Tests.ps1 | % { . $_.FullName }
Get-ChildItem "$MODULE_PUBLIC_DIR\*.ps1" -exclude *.Tests.ps1 | % { . $_.FullName }
Get-ChildItem "$MODULE_HELPERS_DIR\*.ps1" -exclude *.Tests.ps1 | % { . $_.FullName }

# Export functions
Export-ModuleMember -Function (Get-ChildItem "$MODULE_PUBLIC_DIR\*.ps1" | Select-Object -ExpandProperty BaseName)
