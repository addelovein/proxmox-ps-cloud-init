# Set Hostname  #shutdown.exe -r -t 30 /c "The computer will RESTART in 30 seconds due to COMPUTERNAME change."
Write-Host "Renaming computer"  -F White

$HOSTNAME=$HOSTNAME -replace '_','-'
$HOSTNAME.substring(0, [System.Math]::Min(10, $HOSTNAME.Length))

Write-Host "Current HOSTNAME: $(iex hostname)"
Write-Host "Config  HOSTNAME: $(HOSTNAME)"
if((iex hostname) -ne $HOSTNAME){
    Rename-Computer -NewName $HOSTNAME -ErrorAction Ignore -Confirm $false
}