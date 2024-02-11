#Setup WinRM
Write-Host "Setting WinRM"  -F White

Write-Host "Setup WinRM unsecure mode" -F Yellow
    winrm quickconfig -quiet
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
    winrm set winrm/config/service/auth '@{Basic="true"}'
# NOT RECOMENDED BELOW
    Set-Item wsman:\localhost\client\trustedhosts -Value 192.168.1.* -Concatenate -confirm:$false -Force
    Set-Item wsman:\localhost\client\trustedhosts -Value 192.168.0.* -Concatenate -confirm:$false -Force
