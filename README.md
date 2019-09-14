# Setup-ScheduledTask

```powershell
Import-Module ./Setup-ScheduledTask.psm1 -Force

# Specified definition file
Setup-ScheduledTask -DefinitionFile "C:\path\to\definition.ps1"

# Specified definition directory containing .ps1 definition files
Setup-ScheduledTask -DefinitionDirectory "C:\path\to\definition\directory\"
```

## Tips

- You can use the `-Verbose` for verbose output.
