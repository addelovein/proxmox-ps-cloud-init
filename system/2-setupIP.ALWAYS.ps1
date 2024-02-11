$IP
$GATEWAY
$SUBNET
$DNS
$DNS_SEARCH

Write-Host "Setting IP"  -F White
if ($IP) {
    $NetInterface = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.InterfaceIndex -eq (Get-NetIPInterface -AddressFamily IPv4 -ConnectionState Connected -InterfaceAlias Ethernet).ifIndex}
    
    if($NetInterface.IPAddress){
        if(!$NetInterface.IPAddress.Contains("$IP")) { $NetInterface.EnableStatic($IP, $SUBNET) }
    }else{
        $NetInterface.EnableStatic($IP, $SUBNET)
    }
    if($NetInterface.DefaultIPGateway){
        if(!$NetInterface.DefaultIPGateway.Contains("$GATEWAY")) { $NetInterface.SetGateways($GATEWAY) }
    }else{
        $NetInterface.SetGateways($GATEWAY)
    }
    if($NetInterface.DNSServerSearchOrder){
        if(!$NetInterface.DNSServerSearchOrder.Contains("$DNS")) { $NetInterface.SetDNSServerSearchOrder($DNS) }
    }else{
        $NetInterface.SetDNSServerSearchOrder($DNS)
    }
    if($NetInterface.DNSDomain){
        if(!$NetInterface.DNSDomain.Contains("$DNS_SEARCH")) { $NetInterface.SetDNSDomain($DNS_SEARCH) }
    }else{
        $NetInterface.SetDNSDomain($DNS_SEARCH)
    }
}else{
    Write-Host "No IP Specified" -F Yellow
}
