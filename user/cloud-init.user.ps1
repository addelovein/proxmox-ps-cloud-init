Remove-Item C:\cloud-init\userlog.ps1 -ErrorAction Ignore
Start-Transcript -Path "C:\cloud-init\userlog.txt" -NoClobber

whoami

Get-ChildItem "c:\cloud-init\user\[0-9]*.ps1"  | ForEach-Object { 
	Write-Host ""
	Write-Host "Running user script: $($_.FullName)" -F Cyan
	invoke-expression -Command $_.FullName
	Write-Host ""
}  


Stop-Transcript