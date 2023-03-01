[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [string]$TaskName = "$VMName as a service",
    [Parameter(Mandatory=$false)]
    [string]$TaskDescription = "Vbox VM $VMName as a service at startup", 
    [Parameter(Mandatory=$true)]
    [string]$VMName,
    [Parameter(Mandatory=$false)]
    [string]$TaskPath = "My Custom Tasks",
    [Parameter(Mandatory=$false)]
    [string]$VBoxManagePath = "C:\PROGRA~1\Oracle\VirtualBox\VBoxManage.exe",
    [Parameter(Mandatory=$false)]
    [ValidateSet("AtStartup", "Once", "Daily", "Weekly", "Monthly", "OnIdle")]
    [string]$Trigger = "AtStartup",
    [Parameter(Mandatory=$false)]
    [string]$User = "NT AUTHORITY\SYSTEM",
    [Parameter(Mandatory=$false)]
    [ValidateSet("Highest", "Limited")]
    [string]$RunLevel = "Highest",
    [Parameter(Mandatory=$false)]
    [DateTime]$StartTime = (Get-Date),
    [Parameter(Mandatory=$false)]
    [DateTime]$StartDate = (Get-Date),
    [Parameter(Mandatory=$false)]
    [string]$DaysofWeek = "Monday,Wednesday,Friday",
    [Parameter(Mandatory=$false)]
    [string]$DaysofMonth = "1,15",
    [Parameter(Mandatory=$false)]
    [string]$Weeksinterval = "1",
    [Parameter(Mandatory=$false)]
    [string]$Monthsinterval = "1"   

)

# Create task
$action = New-ScheduledTaskAction -Execute $VBoxManagePath -Argument "startvm $VMName --type headless"

switch ($Trigger) {
    "AtStartup" {
        $trigger = New-ScheduledTaskTrigger -AtStartup
    }
    "Once" {
        $dateTime = $StartDate.AddHours($StartTime.Hour).AddMinutes($StartTime.Minute)
        $trigger = New-ScheduledTaskTrigger -Once $dateTime
    }
    "Daily" {
        $trigger = New-ScheduledTaskTrigger -Daily -At $StartTime
    }
    "Weekly" {
        $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek $DaysofWeek -At $StartTime -WeeksInterval $Weeksinterval -StartDate $StartDate
    }
    "Monthly" {
        $trigger = New-ScheduledTaskTrigger -Monthly -DaysOfMonth $DaysofMonth -At $StartTime -MonthsInterval $Monthsinterval -StartDate $StartDate
    }
    "OnIdle" {
        $trigger = New-ScheduledTaskTrigger -OnIdle -RandomDelay (New-TimeSpan -Minutes 15)
    }
    default {
        Write-Error "Invalid value for Trigger parameter: $Trigger"
        return
    }
}

$principal = New-ScheduledTaskPrincipal -UserId $User -RunLevel $RunLevel
$setting = New-ScheduledTaskSettingsSet -RestartInterval (New-TimeSpan -Minutes 5) -RestartCount 3 -ExecutionTimeLimit 365 -AllowStartIfOnBatteries
Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $setting -TaskPath $TaskPath -TaskName $TaskName -Description $TaskDescription
