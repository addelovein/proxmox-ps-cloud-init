#Remove-Item C:\cloud-init\unattendedlog.ps1 -ErrorAction Ignore
Start-Transcript -Path "C:\cloud-init\system.txt"
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

# Store Regex Values in easy to access Variables
$IP = $ip.Matches.Groups[1].Value;
$GATEWAY = $gw.Matches.Groups[1].Value;
$SUBNET = $sn.Matches.Groups[1].Value;
$DNS = $dns_nameservers.Matches.Groups[1].Value;
$DNS_SEARCH = $dns_search.Matches.Groups[1].Value;

# Open Userdata file
$yaml = Get-Content "$($drive):\OPENSTACK\LATEST\USER_DATA" | Out-String | ConvertFrom-Yaml
#$USER_PASS = $yaml.password
$USER_NAME = $yaml.users
$SSH_PUB = $yaml.ssh_authorized_keys

$USER_NAME=$USER_NAME -replace 'default','Administrator'

#Write-Host "Creating User Credential"
#$USER_CREDENTIAL = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $USER_NAME, $ADMIN_PASSWORD

Get-ChildItem "c:\cloud-init\system\[0-9]*.ps1"  | ForEach-Object { 
	Write-Host ""
	Write-Host "Running system script: $($_.FullName)" -F Cyan
	invoke-expression -Command $_.FullName
	Write-Host ""
}

$ProgressPreference = 'Continue'
Stop-Transcript
