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
    [string]$RunLevel = "Highest"
)

# Create task
$action = New-ScheduledTaskAction -Execute $VBoxManagePath -Argument "startvm $VMName --type headless"
$trigger = New-ScheduledTaskTrigger -$Trigger
$principal = New-ScheduledTaskPrincipal -UserId $User -RunLevel $RunLevel
$setting = New-ScheduledTaskSettingsSet -RestartInterval (New-TimeSpan -Minutes 5) -RestartCount 3 -ExecutionTimeLimit 365 -AllowStartIfOnBatteries
Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $setting -TaskPath $TaskPath -TaskName $TaskName -Description $TaskDescription
