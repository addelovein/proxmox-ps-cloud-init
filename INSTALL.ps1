Write-Host "Install Proxmox-cloud-init" -F Blue
$ORIG=$pwd.path
Write-Host "Username process" -F Blue

$USERNAME = Read-Host -Prompt "Admin account Username [Administrator]"
$PASSWORD = Read-Host -Prompt "Admin account Password (Press Enter For None, You must then set after every deploy)"

if ($USERNAME.Length -gt 2){
	$USERNAME | Out-File c:\cloud-init\username.store
}

if ($PASSWORD.Length -gt 3){
    #Create Key
    #----------
    $KeyFile = "c:\cloud-init\key.store"
    $Key = New-Object Byte[] 32
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
    $Key | out-file $KeyFile

    #CREATE STRING
    #-------------
    $PASSWORD | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString -Key $Key | Out-File c:\cloud-init\password.store
}


Get-PackageProvider -name nuget -force
Install-Module -Name powershell-yaml -confirm:$false -Force
Set-Location c:\cloud-init\
C:\Windows\System32\sysprep\sysprep.exe /generalize /oobe /unattend:c:\cloud-init\Unattend.xml
Set-Location $ORIG