# Switch network connection to private mode Required for WinRM firewall rules
Write-Host "Setting network to Private" -F White
$profilex = Get-NetConnectionProfile
Set-NetConnectionProfile -Name $profilex.Name -NetworkCategory Private