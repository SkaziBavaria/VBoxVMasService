## PowerShell Script: Run VirtualBox VM as a Service at Startup

This PowerShell script creates a Windows Scheduled Task that runs a VirtualBox virtual machine as a service at system startup. The virtual machine will run in headless mode, meaning there is no GUI displayed on the host machine.

### Prerequisites

- Windows PowerShell version 3.0 or later
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
 must be installed on the host machine.
- The virtual machine that you want to run as a service must already exist in VirtualBox.

### Usage

1. Download the `VBoxServiceTask.ps1` script to  your computer.
2. Open PowerShell with Administrator privileges.
3. Navigate to the directory where the script is saved.
4. Run the script with the required `-VMName` parameter, and any optional parameters you want to use:
```powershell
# Replace "MyVM" with the name of the virtual machine that you want to run as a service.
.\VBoxServiceTask.ps1 -VMName "MyVM"
```
5. The script will create a Windows Scheduled Task that runs the virtual machine as a service at system startup.

### Customizing the Script

The script has several parameters that you can customize:

| Parameter	        | Description	        | Default       |
| ---------         | -----------           | ------        |
|`-VMName`          |	(required) The name of the VirtualBox VM to run as a service.	| N/A |
| `-VBoxManagePath` |	(optional) The path to the VBoxManage.exe executable.  Default is `"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"`. If your installation path is different, modify this parameter accordingly.	| `"C:\PROGRA~1\Oracle\VirtualBox\VBoxManage.exe"` |
| `-Trigger`        |	(optional) The task trigger to use. Possible values: `"AtStartup"` (default), `"Once"`, `"Daily"`, `"Weekly"`, `"Monthly"`, `"OnIdle"`. |	`"AtStartup"` |
| `-User`           |	(optional) The user account to run the task as. |	`"NT AUTHORITY\SYSTEM"` |
| `-RunLevel`       |	(optional) The run level of the task. Possible values: `"Highest"` (default), `"Limited"`.	      |`"Highest"` |
| `-TaskName`       |	(optional) The name of the task. |	`"$VMName as a service"` |
| `-TaskDescription` |	(optional) The description of the task. |	`"Vbox VM $VMName as a service at startup"` |
| `TaskPath`        |	(optional) The path to the task. |	`"My Custom Tasks"` |
|`-StartDate`       | (optional) The date when the task should start running. Format: `MM/DD/YYYY`. | Current date |
|`-StartTime`       | (optional) The time when the task should start running. Format: `HH:MM:SS AM/PM`. | Current time |
| `-DaysOfWeek` | (optional) The days of the week to run the scheduled task (for the Weekly trigger). | `"Monday,Wednesday,Friday"`|
| `-DaysOfMonth`| (optional) The days of the month to run the scheduled task (for the Monthly trigger). | `1,15"`|
|`-WeeksInterval`| (optional) The number of weeks between runs (for the Weekly trigger).|`"1"`|
|`-MonthsInterval`| (optional) The number of months between runs (for the Monthly trigger).| `"1"`

### Examples:
1. Start the task every day at 7:00 AM:
`.\VBoxServiceTask.ps1 -VMName "MyVM" -Trigger Daily -StartTime "07:00"`
2. Start the task every Monday at 9:00 AM: 
`.\VBoxServiceTask.ps1 -VMName "MyVM" -Trigger Weekly -DaysOfWeek Monday -StartTime "09:00"`
3. Start the task on a specific date and time: 
`.\VBoxServiceTask.ps1 -VMName "MyVM" -Trigger Once -StartDate "2023-03-01" -StartTime "10:00"`

### Troubleshooting

- If you receive an error about the script being unsigned, you can change your PowerShell execution policy to RemoteSigned by running the following command as an administrator:
`Set-ExecutionPolicy RemoteSigned`

- If you receive an error about the VirtualBox installation directory not being found, you can specify the path to the VBoxManage.exe executable with the -VBoxManagePath parameter.
`.\VBoxServiceTask.ps1 -VMName "MyVM" -VBoxManagePath "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"`

### License
This script is released under the [MIT License](./LICENSE)
. See LICENSE for more information.
