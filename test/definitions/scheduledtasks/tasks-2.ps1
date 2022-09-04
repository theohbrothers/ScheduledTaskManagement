@(
    @{
        TaskName = 'MyTaskName4'
        TaskPath = '\MyTaskFolder\'
        Trigger = @(
            @{
                AtStartup = $true
                # At = @{
                #     Year = 1999
                #     Month = 11
                #     Day = 30
                #     Hour = 0
                #     Minute = 0
                #     Second = 0
                # }
                # Daily = $true
                # DaysInterval = 1
                # Once = $true
                # RepetitionDuration = @{
                #     Days = 9999
                # }
                # RepetitionInterval = @{
                #     Hour = 12
                #     Minute = 0
                #     Second = 0
                # }
            }
            @{
                # AtStartup = $true
                At = @{
                    Year = 1999
                    Month = 11
                    Day = 30
                    Hour = 17
                    Minute = 30
                    Second = 0
                }
                Daily = $true
                DaysInterval = 1
                # Once = $true
                # RepetitionDuration = @{
                #     Days = 9999
                # }
                # RepetitionInterval = @{
                #     Hour = 12
                #     Minute = 0
                #     Second = 0
                # }
            }
        )
        Action = @(
            @{
                Execute = 'powershell'
                Argument = @'
-NonInteractive -NoProfile -NoLogo -Command 'New-Item "$env:TEMP\$(Get-Date -UFormat .%s-4-1)"'
'@
            }
            @{
                Execute = 'powershell'
                Argument = @'
-NonInteractive -NoProfile -NoLogo -Command 'New-Item "$env:TEMP\$(Get-Date -UFormat .%s-4-2)"'
'@
            }
        )
        Settings = @{
            Disable = $false
            AllowStartIfOnBatteries = $true
            DontStopIfGoingOnBatteries = $true
        }
        Principal = @{
            UserId = 'VssAdministrator'
            LogonType = 'S4U'
            RunLevel = 'Highest'
        }
    }

    @{
        TaskName = 'MyTaskName5'
        TaskPath = '\MyTaskFolder\'
        Trigger = @(
            @{
                # AtStartup = $true
                At = @{
                    Year = 1999
                    Month = 11
                    Day = 30
                    Hour = 14
                    Minute = 0
                    Second = 0
                }
                # Daily = $true
                # DaysInterval = 1
                Once = $true
                RepetitionDuration = @{
                    Days = 9999
                }
                RepetitionInterval = @{
                    Hour = 12
                    Minute = 0
                    Second = 0
                }
            }
        )
        Action = @(
            @{
                Execute = 'powershell'
                Argument = @'
-NonInteractive -NoProfile -NoLogo -Command 'New-Item "$env:TEMP\$(Get-Date -UFormat .%s-5-1)"'
'@
            }
            @{
                Execute = 'powershell'
                Argument = @'
-NonInteractive -NoProfile -NoLogo -Command 'New-Item "$env:TEMP\$(Get-Date -UFormat .%s-5-2)"'
'@
            }
        )
        Settings = @{
            Disable = $false
            AllowStartIfOnBatteries = $true
            DontStopIfGoingOnBatteries = $true
        }
        Principal = @{
            UserId = 'NT AUTHORITY\SYSTEM'
            LogonType = 'S4U'
            RunLevel = 'Limited'
        }
    }

    @{
        TaskName = 'MyTaskName6'
        TaskPath = '\MyTaskFolder\'
        Trigger = @(
            @{
                # AtStartup = $true
                At = @{
                    Year = 1999
                    Month = 11
                    Day = 30
                    Hour = 10
                    Minute = 0
                    Second = 0
                }
                Daily = $true
                DaysInterval = 1
                # Once = $true
                # RepetitionDuration = @{
                #     Days = 9999
                # }
                # RepetitionInterval = @{
                #     Hour = 12
                #     Minute = 0
                #     Second = 0
                # }
            }
            @{
                # AtStartup = $true
                At = @{
                    Year = 1999
                    Month = 11
                    Day = 30
                    Hour = 14
                    Minute = 0
                    Second = 0
                }
                Daily = $true
                DaysInterval = 1
                # Once = $true
                # RepetitionDuration = @{
                #     Days = 9999
                # }
                # RepetitionInterval = @{
                #     Hour = 12
                #     Minute = 0
                #     Second = 0
                # }
            }
            @{
                # AtStartup = $true
                At = @{
                    Year = 1999
                    Month = 11
                    Day = 30
                    Hour = 18
                    Minute = 0
                    Second = 0
                }
                Daily = $true
                DaysInterval = 1
                # Once = $true
                # RepetitionDuration = @{
                #     Days = 9999
                # }
                # RepetitionInterval = @{
                #     Hour = 12
                #     Minute = 0
                #     Second = 0
                # }
            }
            @{
                # AtStartup = $true
                At = @{
                    Year = 1999
                    Month = 11
                    Day = 30
                    Hour = 22
                    Minute = 0
                    Second = 0
                }
                Daily = $true
                DaysInterval = 1
                # Once = $true
                # RepetitionDuration = @{
                #     Days = 9999
                # }
                # RepetitionInterval = @{
                #     Hour = 12
                #     Minute = 0
                #     Second = 0
                # }
            }
        )
        Action = @(
            @{
                Execute = 'powershell'
                Argument = @'
-NonInteractive -NoProfile -NoLogo -Command 'New-Item "$env:TEMP\$(Get-Date -UFormat .%s-6-1)"'
'@
            }
            @{
                Execute = 'powershell'
                Argument = @'
-NonInteractive -NoProfile -NoLogo -Command 'New-Item "$env:TEMP\$(Get-Date -UFormat .%s-6-2)"'
'@
            }
            @{
                Execute = 'powershell'
                Argument = @'
-NonInteractive -NoProfile -NoLogo -Command 'New-Item "$env:TEMP\$(Get-Date -UFormat .%s-6-3)"'
'@
            }
        )
        Settings = @{
            Disable = $false
            AllowStartIfOnBatteries = $true
            DontStopIfGoingOnBatteries = $true
        }
        Principal = @{
            UserId = 'VssAdministrator'
            LogonType = 'S4U'
            RunLevel = 'Highest'
        }
    }
)
