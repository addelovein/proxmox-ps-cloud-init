# Show ENV For Debug
gv -s 0

Remove-Item C:\cloud-init\startup.ps1 -ErrorAction Ignore
Start-Transcript -Path "C:\cloud-init\startup.txt"
$ProgressPreference = 'SilentlyContinue'

# Get Config-2 Drive letter
$drive = (Get-Volume -FriendlyName "config-2").DriveLetter

# Read META_DATA.json and Store as an Object
$json = Get-Content "$($drive):\OPENSTACK\LATEST\META_DATA.json" | Out-String | ConvertFrom-Yaml
#$json.uuid
$HOSTNAME=$json.hostname
#$ADMIN_PASS=$json.meta.admin_pass

# Open network file referenced in META_DATA
$file = Get-Content "$($drive):\OPENSTACK$($json.network_config.content_path)"

# Get Data using RegEx
$ip = $file | Select-String -Pattern '(?<=address\s)(.*)'
$gw = $file | Select-String -Pattern '(?<=gateway\s)(.*)'
$sn = $file | Select-String -Pattern '(?<=netmask\s)(.*)'
$dns_nameservers = $file | Select-String -Pattern '(?<=dns_nameservers\s)(.*)'
$dns_search = $file | Select-String -Pattern '(?<=dns_search\s)(.*)'

$IP = $ip.Matches.Groups[1].Value;
$GATEWAY = $gw.Matches.Groups[1].Value;
$SUBNET = $sn.Matches.Groups[1].Value;
$DNS = $dns_nameservers.Matches.Groups[1].Value;
$DNS_SEARCH = $dns_search.Matches.Groups[1].Value;

$yaml = Get-Content "$($drive):\OPENSTACK\LATEST\USER_DATA" | Out-String | ConvertFrom-Yaml

$SSH_PUB = $yaml.ssh_authorized_keys

Get-ChildItem "c:\cloud-init\system\[0-9]*.ALWAYS.ps1"  | ForEach-Object { 
	Write-Host ""
	Write-Host "Running system script: $($_.FullName)" -F Cyan
	invoke-expression -Command $_.FullName
	Write-Host ""
}

$ProgressPreference = 'Continue'
Stop-Transcript
