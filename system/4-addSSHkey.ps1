#Setup SSH Public Key
Write-Host "Setting SSH Public Keys" -F White

if ($SSH_PUB) {
#    Write-Host "Install and setup OpenSSH" -F Cyan
#    Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*Server*' | Add-WindowsCapability -Online
#    Set-Service -StartupType Automatic sshd
#    Start-Service sshd

#   Write-Host "Start SSH-AGENT service" -F Cyan
#   Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service

    Write-Host "Installing public key to Administrators .ssh folder" -F Blue
#    Add-Content "$env:USERPROFILE\.ssh\authorized_keys" $SSH_PUB
    Add-Content -Force -Path c:\ProgramData\ssh\administrators_authorized_keys -Value $SSH_PUB;
    icacls.exe "c:\ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
}else{
    Write-Host "No SSH Public key supplied." -F Yellow
}
