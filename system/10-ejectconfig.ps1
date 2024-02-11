
Write-Host "Ejecting Config Drive" -F White

$drive = (Get-Volume -FriendlyName "config-2" -ErrorAction Ignore).DriveLetter
[bool]$drive
if ($drive) {
    $driveEject = New-Object -comObject Shell.Application
    $driveEject.Namespace(17).ParseName("$($drive):").InvokeVerb("Eject")
}
