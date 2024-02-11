#Remove-Item C:\cloud-init\userlog.ps1 -ErrorAction Ignore
Start-Transcript -Path "C:\cloud-init\user.always.txt"

whoami

Get-ChildItem "c:\cloud-init\user\[0-9]*.ALWAYS.ps1"  | ForEach-Object { 
	Write-Host ""
	Write-Host "Running user script: $($_.FullName)" -F Cyan
	invoke-expression -Command $_.FullName
	Write-Host ""
}  

Stop-Transcript