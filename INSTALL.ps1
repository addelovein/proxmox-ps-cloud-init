Write-Host "Install Proxmox-cloud-init" -F Blue
$ORIG=$pwd.path

Get-PackageProvider -name nuget -force
Install-Module -Name powershell-yaml -confirm:$false -Force
Set-Location c:\cloud-init\
C:\Windows\System32\sysprep\sysprep.exe /generalize /oobe /unattend:c:\cloud-init\Unattend.xml
Set-Location $ORIG