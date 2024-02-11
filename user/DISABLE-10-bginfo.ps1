$bgInfoFolder = "C:\BgInfo"
$bgInfoFolderContent = $bgInfoFolder + "\*"
$itemType = "Directory"
$bgInfoUrl = "https://download.sysinternals.com/files/BGInfo.zip"
$bgInfoZip = "C:\BgInfo\BgInfo.zip"
$bgInfoEula = "C:\BgInfo\Eula.txt"
$bgInfoRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$bgInfoRegkey = "BgInfo"
$bgInfoRegType = "String"
$bgInfoRegkeyValue = "C:\BgInfo\Bginfo.exe C:\cloud-init\bginfo\logon.bgi /timer:0 /nolicprompt"
$regKeyExists = (Get-Item $bgInfoRegPath -EA Ignore).Property -contains $bgInfoRegkey
$foregroundColor1 = "Yellow"
$foregroundColor2 = "White"
$writeEmptyLine = "`n"
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Start script execution
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Create BgInfo folder on C: if it not exists, else delete it's content
If (!(Test-Path -Path $bgInfoFolder))
{
       New-Item -ItemType $itemType -Force -Path $bgInfoFolder
       Write-Host ($writeEmptyLine + "# BgInfo folder created")`
       -foregroundcolor $foregroundColor2 $writeEmptyLine
}
Else
{
       Write-Host ($writeEmptyLine + "# BgInfo folder already exists")`
       -foregroundcolor $foregroundColor2 $writeEmptyLine
       Remove-Item $bgInfoFolderContent -Force -Recurse -ErrorAction SilentlyContinue
       Write-Host ($writeEmptyLine + "# Content existing BgInfo folder deleted")`
       -foregroundcolor $foregroundColor2 $writeEmptyLine
}
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Download, save and extract latest BgInfo software to C:\BgInfo
Import-Module BitsTransfer
Start-BitsTransfer -Source $bgInfoUrl -Destination $bgInfoZip
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory($bgInfoZip, $bgInfoFolder)
Remove-Item $bgInfoZip
Remove-Item $bgInfoEula

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Create BgInfo Registry Key to AutoStart
If ($regKeyExists -eq $True)
{
   Write-Host ($writeEmptyLine + "# BgInfo regkey exists, script wil go on")`
   -foregroundcolor $foregroundColor1 $writeEmptyLine
}
Else
{
   New-ItemProperty -Path $bgInfoRegPath -Name $bgInfoRegkey -PropertyType $bgInfoRegType -Value $bgInfoRegkeyValue 
   Write-Host ($writeEmptyLine + "# BgInfo regkey added")`
   -foregroundcolor $foregroundColor2 $writeEmptyLine
}
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Run BgInfo
C:\BgInfo\Bginfo.exe C:\cloud-init\bginfo\logon.bgi /timer:0 /nolicprompt
 