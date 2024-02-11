Write-Host "Install Proxmox-cloud-init" -F Blue
Get-PackageProvider -name nuget -force
Install-Module -Name powershell-yaml -confirm:$false -Force
cd \cloud-init\
C:\Windows\System32\sysprep\sysprep.exe /generalize /oobe /unattend:Unattend.xml