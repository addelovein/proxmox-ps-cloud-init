# Set Hostname  #shutdown.exe -r -t 30 /c "The computer will RESTART in 30 seconds due to COMPUTERNAME change."
Write-Host "Renaming computer"  -F White

$HOSTNAME=$HOSTNAME -replace '_','-'
$HOSTNAME=$HOSTNAME.substring(0, [System.Math]::Min(15, $HOSTNAME.Length))

Write-Host "Current HOSTNAME: $(Invoke-Expression hostname)"
Write-Host "Config  HOSTNAME: $HOSTNAME"
if((Invoke-Expression hostname) -ne $HOSTNAME){
    Rename-Computer -NewName $HOSTNAME -ErrorAction Ignore
}