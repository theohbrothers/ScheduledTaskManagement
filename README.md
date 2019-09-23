# Setup-ScheduledTask

```powershell
Import-Module .\Setup-ScheduledTask.psm1 -Force

# .ps1 definition file
Setup-ScheduledTask -DefinitionFile "C:\path\to\definition.ps1"

# .json definition file
Setup-ScheduledTask -DefinitionFile "C:\path\to\definition.json" -AsJson

# Directory containing .ps1 definition files
Setup-ScheduledTask -DefinitionDirectory "C:\path\to\definition\directory\"

# Directory containing .json definition files
Setup-ScheduledTask -DefinitionDirectory "C:\path\to\definition\directory\" -AsJson
```

## Tips

- You can use the `-Verbose` for verbose output.
