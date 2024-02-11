Write-Host "Install Proxmox-cloud-init" -F Blue
$ORIG=$pwd.path

Get-PackageProvider -name nuget -force
Install-Module -Name powershell-yaml -confirm:$false -Force
cd c:\cloud-init\
C:\Windows\System32\sysprep\sysprep.exe /generalize /oobe /unattend:c:\cloud-init\Unattend.xml
cd $ORIG