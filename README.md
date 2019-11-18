# ScheduledTaskManagement

```powershell
Import-Module .\src\ScheduledTaskManagement\ScheduledTaskManagement.psm1 -Force -Verbose

# .ps1 definition file
Setup-ScheduledTask -DefinitionFile "C:\path\to\definition.ps1"

# .json definition file
Setup-ScheduledTask -DefinitionFile "C:\path\to\definition.json" -AsJson

# Directory containing .ps1 definition files
Setup-ScheduledTask -DefinitionDirectory "C:\path\to\definition\directory\"

# Directory containing .json definition files
Setup-ScheduledTask -DefinitionDirectory "C:\path\to\definition\directory\" -AsJson

# Definition objects
Setup-ScheduledTask -DefinitionObject $objects
```

## Tips

- `-DefinitionFile`, `-DefinitionDirectory`, and `-DefinitionObject` accept an array of objects.
- You can use the `-Verbose` for verbose output.
