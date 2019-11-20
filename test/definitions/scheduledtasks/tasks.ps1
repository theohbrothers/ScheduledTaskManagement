@(
    @{
        TaskName = 'MyTaskName1'
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
                # RepetitionInterval = @{
                #     Hour = 12
                #     Minute = 0
                #     Second = 0
                # }
                # RepetitionDuration = @{
                #     Days = 9999
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
                Argument = '-NonInteractive -NoProfile -NoLogo -Command "Get-Date -UFormat .%s.1 | % { New-Item R:\$_ }"'
            }
            @{
                Execute = 'powershell'
                Argument = '-NonInteractive -NoProfile -NoLogo -Command "Get-Date -UFormat .%s.2 | % { New-Item R:\$_ }"'
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
        TaskName = 'MyTaskName2'
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
                Argument = '-NonInteractive -NoProfile -NoLogo -Command "Get-Date -UFormat .%s.1 | % { New-Item R:\$_ }"'
            }
            @{
                Execute = 'powershell'
                Argument = '-NonInteractive -NoProfile -NoLogo -Command "Get-Date -UFormat .%s.2 | % { New-Item R:\$_ }"'
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
        TaskName = 'MyTaskName3'
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
                Argument = '-NonInteractive -NoProfile -NoLogo -Command "Get-Date -UFormat .%s.1 | % { New-Item R:\$_ }"'
            }
            @{
                Execute = 'powershell'
                Argument = '-NonInteractive -NoProfile -NoLogo -Command "Get-Date -UFormat .%s.2 | % { New-Item R:\$_ }"'
            }
            @{
                Execute = 'powershell'
                Argument = '-NonInteractive -NoProfile -NoLogo -Command "Get-Date -UFormat .%s.3 | % { New-Item R:\$_ }"'
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
