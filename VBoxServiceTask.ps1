# This script registers a scheduled task for starting a VirtualBox VM based on the provided parameters.
# Usage: ./script_name.ps1 -VMName <vm_name> [additional optional parameters]
param (
    [Parameter(Mandatory=$true)][string]$VMName,
    [string]$VBoxManagePath = "C:\PROGRA~1\Oracle\VirtualBox\VBoxManage.exe",
    [ValidateSet("AtStartup", "Once", "Daily", "Weekly", "AtLogOn")][string]$Frequency = "AtStartup",
    [string]$User = "NT AUTHORITY\SYSTEM",
    [ValidateSet("Limited", "Highest")][string]$RunLevel = "Highest",
    [string]$TaskName = "Start-VM-$VMName",
    [string]$TaskDescription = "Vbox VM $VMName as a service at startup",
    [string]$TaskPath = "My Custom Tasks",
    [string]$StartDate = (Get-Date -Format 'yyyy-MM-dd'),
    [string]$StartTime = (Get-Date -Format 'HH:mm'),
    [ValidateRange(1, [int]::MaxValue)][int]$DaysInterval = 1,
    [string]$DaysOfWeek = "",
    [ValidateRange(1, [int]::MaxValue)][int]$WeeksInterval = 1
)

# Check if VBoxManage.exe exists at the specified path
if (-not (Test-Path $VBoxManagePath)) {
    Write-Error "VBoxManage.exe not found at the specified path. Please check the VBoxManagePath parameter."
    return
}

$action = New-ScheduledTaskAction -Execute $VBoxManagePath -Argument "startvm `"$VMName`" --type headless"

# Create a trigger based on the specified frequency
switch ($Frequency) {
    "AtStartup" { $Trigger = New-ScheduledTaskTrigger -AtStartup }
    "Once" { $Trigger = New-ScheduledTaskTrigger -Once -At ($StartDate + "T" + $StartTime) }
    "Daily" { $Trigger = New-ScheduledTaskTrigger -Daily -At ($StartDate + "T" + $StartTime) -DaysInterval $DaysInterval }
    "Weekly" {
        $DaysOfWeekArray = $DaysOfWeek -split ',' | ForEach-Object { [System.DayOfWeek]$_ }
        $Trigger = New-ScheduledTaskTrigger -Weekly -At ($StartDate + "T" + $StartTime) -DaysOfWeek $DaysOfWeekArray -WeeksInterval $WeeksInterval
    }
    "AtLogOn" { $Trigger = New-ScheduledTaskTrigger -AtLogOn -User $User }
}

$principal = New-ScheduledTaskPrincipal -UserID $User -LogonType ServiceAccount -RunLevel $RunLevel
$settings = New-ScheduledTaskSettingsSet `
    -RestartInterval (New-TimeSpan -Minutes 5) `
    -RestartCount 3 `
    -ExecutionTimeLimit (New-TimeSpan -Days 365) `
    -AllowStartIfOnBatteries

# Register the scheduled task and handle any errors that may occur
try {
    Register-ScheduledTask -Action $action -Trigger $Trigger -Principal $principal -Settings $settings -TaskName $TaskName -TaskPath $TaskPath -Description $TaskDescription
} catch {
    Write-Error "An error occurred while
