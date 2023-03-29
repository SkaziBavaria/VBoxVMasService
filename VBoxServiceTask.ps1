# This script creates a scheduled task for starting a VirtualBox VM according to the specified Frequency.

param (
    # Name of the VirtualBox VM to start.
    [Parameter(Mandatory=$true)]
    [string]$VMName,

    # Frequency frequency for the scheduled task.
    # Possible values: Once, Daily, Weekly, Monthly, AtLogOn, AtStartup
    [Parameter(Mandatory=$true)]
    [ValidateSet("Once", "Daily", "Weekly", "Monthly", "AtLogOn", "AtStartup")]
    [string]$Frequency = "AtStartup",

    # Name of the scheduled task.
    [Parameter(Mandatory=$true)]
    [string]$TaskName = "Start-VM-$VMName",

    # Run level for the scheduled task.
    # Possible values: Highest, Limited
    [ValidateSet("Highest", "Limited")]
    [string]$RunLevel = "Highest",

    # Path for the scheduled task.
    [string]$TaskPath = "My Custom Tasks",

    # Description for the scheduled task.
    [string]$TaskDescription = "Vbox VM $VMName as a service at startup",

    # Path to the VBoxManage executable.
    [string]$VBoxManagePath = "C:\PROGRA~1\Oracle\VirtualBox\VBoxManage.exe",

    # Start date for the scheduled task (format: yyyy-MM-dd).
    [string]$StartDate,

    # Start time for the scheduled task (format: HH:mm).
    [string]$StartTime,

    # Interval in days for the daily Frequency.
    [UInt32]$DaysInterval,

    # Days of the week for the weekly Frequency.
    # Possible values: Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    [DayOfWeek[]]$DaysOfWeek,

    # Interval in weeks for the weekly Frequency.
    [UInt32]$WeeksInterval,

    # Days of the month for the monthly Frequency (1-31).
    [UInt32[]]$DaysOfMonth,

    # Months of the year for the monthly Frequency (1-12).
    [UInt32[]]$MonthsOfYear,

    # User account to run the scheduled task.
    [string]$User = "NT AUTHORITY\SYSTEM"
)

# Combine the start date and time into a single DateTime object.
$combinedDateTime = [DateTime]::ParseExact("$StartDate $StartTime", "yyyy-MM-dd HH:mm", $null)

# Create a new scheduled task action to start the VM.
$action = New-ScheduledTaskAction -Execute $VBoxManagePath -Argument "startvm $VMName --type headless"

# Set the Frequency based on the specified frequency.
switch ($Frequency) {
    "Once" {
        $Frequency = New-ScheduledTaskFrequency -Once -At $combinedDateTime
    }
    "Daily" {
        if ($DaysInterval -gt 0) {
            $Frequency = New-ScheduledTaskFrequency -Daily -At $combinedDateTime -DaysInterval $DaysInterval
        } else {
            $Frequency = New-ScheduledTaskFrequency -Daily -At $combinedDateTime
        }
    }
    "Weekly" {
        $Frequency = New-ScheduledTaskFrequency -Weekly -At $combinedDateTime -DaysOfWeek $DaysOfWeek -WeeksInterval $WeeksInterval
    }
    "Monthly" {
        $Frequency = New-ScheduledTaskFrequency -Once -At $combinedDateTime
        $Frequency.DaysOfMonth = $DaysOfMonth
        $Frequency.MonthsOfYear = $MonthsOfYear
    }
    "AtLogOn" {
        $Frequency = New-ScheduledTaskFrequency -AtLogOn -User $User
    }
    "AtStartup" {
        $Frequency = New-ScheduledTaskFrequency -AtStartup
    }
    default {
        Write-Host "Invalid frequency specified. Exiting script."
        exit
    }
}

# Define the settings for the scheduled task.
$settings = New-ScheduledTaskSettingsSet -RestartInterval (New-TimeSpan -Minutes 5) -RestartCount 3 -ExecutionTimeLimit 365 -AllowStartIfOnBatteries

# Define the principal (user account and run level) for the scheduled task.
$principal = New-ScheduledTaskPrincipal -UserId $User -LogonType ServiceAccount -RunLevel $RunLevel

# Register (create) the scheduled task with the provided parameters.
Register-ScheduledTask -Action $action -Trigger $Frequency -Principal $principal -Settings $settings -TaskPath $TaskPath -TaskName $TaskName -Description $TaskDescription
