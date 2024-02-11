Write-Host "Register ScheduledTasks" -F White
Write-Host "Setting up TaskPath" -F Blue
$scheduleObject = New-Object -ComObject schedule.service
$scheduleObject.connect()
$taskpath = "Proxmox-cloud-init"
$rootFolder = $scheduleObject.GetFolder("\")
   Try {$null = $scheduleObject.GetFolder($taskpath)}
   Catch { $null = $rootFolder.CreateFolder($taskpath) }

Write-Host "Create Task Job Eject-Config" -F Blue
$taskName="Main Script"
Write-Host "Register Job $taskName"
$trigger=New-JobTrigger -AtStartup
$action=New-ScheduledTaskAction -Execute PowerShell.exe -Argument "-ExecutionPolicy Bypass -file C:\cloud-init\system\cloud-init.system.ALWAYS.ps1"
Register-ScheduledTask -Action $action -TaskName $taskName -Description "Proxmox Cloud-Init" -RunLevel Highest -Trigger $trigger -User "SYSTEM" -TaskPath Proxmox-cloud-init
