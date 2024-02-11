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
$action=New-ScheduledTaskAction -Execute PowerShell.exe -Argument "-ExecutionPolicy Bypass -WindowStyle hidden -file C:\cloud-init\system\cloud-init.system.ALWAYS.ps1"
Register-ScheduledTask -Action $action -TaskName $taskName -Description "Proxmox Cloud-Init" -RunLevel Highest -Trigger $trigger -User "SYSTEM" -TaskPath Proxmox-cloud-init

$taskName="User Script"
Write-Host "Register Job $taskName"
$action=New-ScheduledTaskAction -Execute PowerShell.exe -Argument "-ExecutionPolicy Bypass -WindowStyle hidden -file C:\cloud-init\user\cloud-init.user.ALWAYS.ps1"
$princ = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
$trigger=New-JobTrigger -AtLogon
Register-ScheduledTask -Action $action -Principal $princ -Trigger $trigger -TaskName $taskName 
