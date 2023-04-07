## PowerShell Script: Run VirtualBox VM as a Service at Startup

This PowerShell script creates a Windows Scheduled Task that runs a VirtualBox virtual machine as a service at system startup. The virtual machine will run in headless mode, meaning there is no GUI displayed on the host machine.

### Prerequisites

- Windows PowerShell version 3.0 or later
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) must be installed on the host machine.
- The virtual machine that you want to run as a service must already exist in VirtualBox.

### Usage

1. Download the `VBoxServiceTask.ps1` script to your computer.
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

| Parameter	        | Description	        | Default       |   Possible Values |
| ---------         | -----------           | ------        | ------------ |
|`-VMName`          |	(required) The name of the VirtualBox VM to run as a service.	| N/A | Any valid VM name|
| `-VBoxManagePath` |	(optional) The path to the VBoxManage.exe executable. If your installation path is not default, modify this parameter accordingly. |`"C:\PROGRA~1\Oracle\VirtualBox\VBoxManage.exe"` |Any valid file path|
| `-Frequency`        |	(optional) The frequency for the scheduled task.|`"AtStartup"`|`"AtStartup"`, `"Once"`, `"Daily"`, `"Weekly"`, `"AtLogOn"`. |
| `-User`           |	(optional) The user account to run the task as. |	`"NT AUTHORITY\SYSTEM"` |Any valid user account|
| `-RunLevel`       |	(optional) The run level of the task. | `"Highest"`| `"Limited"`,`"Highest"` |
| `-TaskName`       | (optional) The name of the task. |  `"Start-VM-$VMName"` |Any valid task name|
| `-TaskDescription` |	(optional) The description of the task. |	`"Vbox VM $VMName as a service at startup"` |Any valid description|
| `TaskPath`        |	(optional) The path to the task. |	`"My Custom Tasks"` |Any valid task path|
|`-StartDate`       | (optional) The date when the task should start running. Format: `yyyy-MM-dd`. | Current date |Any valid date|
|`-StartTime`       | (optional) The time when the task should start running. Format: `HH:mm`. | Current time |Any valid time|
|`DaysInterval`| (optional) Interval in days for the daily trigger.|`1`| Any positive integer |
| `-DaysOfWeek` | (optional) The days of the week to run the scheduled task (for the Weekly trigger). | N/A|`"Sunday"`, `"Monday"`, `"Tuesday"`, `"Wednesday"`, `"Thursday"`, `"Friday"`, `"Saturday"`
| `-WeeksInterval`| (optional) The number of weeks between runs (for the Weekly trigger).|`1`|Any positive integer|

### Additional Settings
The script includes a few additional settings to control the task's behavior in case of failure, execution time limit, and battery power:

- `RestartInterval`: The time interval to wait before restarting a failed task. Default is 5 minutes.
- `RestartCount`: The number of times to attempt to restart the task if it fails. Default is 3.
- `ExecutionTimeLimit`: The maximum time allowed for the task to run. Default is 365 days/Off.
- `AllowStartIfOnBatteries`: If set, the task can start even if the system is on battery power.

These settings are currently hardcoded in the script, but you can modify them directly in the script if you need different values.

### Examples:
1. Start the task at startup:
```powershell
.\VBoxServiceTask.ps1 -VMName "MyVM" -Frequency AtStartup
```

2. Start the task every day at 7:00 AM:
```powershell
.\VBoxServiceTask.ps1 -VMName "MyVM" -Frequency Daily -StartDate "2023-03-01" -StartTime "07:00"
```

3. Start the task every Monday and Friday at 9:00 AM:
```powershell
.\VBoxServiceTask.ps1 -VMName "MyVM" -Frequency Weekly -DaysOfWeek Monday,Friday -StartDate "2023-03-01" -StartTime "09:00"
```

4. Start the task on a specific date and time:
```powershell
.\VBoxServiceTask.ps1 -VMName "MyVM" -Frequency Once -StartDate "2023-03-01" -StartTime "10:00"
```

5. Start the task at user log on:
```powershell
.\VBoxServiceTask.ps1 -VMName "MyVM" -Frequency AtLogOn -User "NT AUTHORITY\SYSTEM"
```

### Troubleshooting

- If you receive an error about the script being unsigned, you can change your PowerShell execution policy to RemoteSigned by running the following command as an administrator:
`Set-ExecutionPolicy RemoteSigned`

- If you receive an error about the VirtualBox installation directory not being found, you can specify the path to the VBoxManage.exe executable with the -VBoxManagePath parameter.
`.\VBoxServiceTask.ps1 -VMName "MyVM" -VBoxManagePath "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"`

### License
This script is released under the [MIT License](./LICENSE)
. See LICENSE for more information.
