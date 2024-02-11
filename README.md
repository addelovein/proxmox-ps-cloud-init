# Proxmox Cloud-Init in Powershell

## Looking for Help!
I am no Powershell genious, however i started this project due to the lack of a simple Sysprep/Proxmox/cloud-init way. There are existing however none that foxuses soulely on proxmox and there for the projects become to complex.

So Are you a Poweradmin/user and see ways to make this better just Forl and give us a PR. (Please document if needed)

## Introducktion
Proxox uses Cloud-init for setting up VMSs. However there is no support for windows.
This is a 100% powershell version that will setup the Hostname (Computer-Name), install SSH keys for OpenSSH if available.

## Implemented functions
* ** Right now only fixed IP or None Supported **
* Setup IP
* Setup Gateway
* Setup Subnetmask
* Setup SSH Keys
* Extend Disk

## Todo
* Fix if user wants DHCP
* A Network required section So the script will check for network connection if its found it will run a cloud-init.network.ps1
* Multiple Network Adapters

## Missing functions
Admin user setup with password is missing this is Due to proxmox suppliyng the password in a SHA hash where Windows would need it in cleartext.
Because of this when machine installs first time it will Ask for Administrator Password. 


## Patch Proxmox to use Username/Password
At : /usr/share/perl5/PVE/API2/Qemu.pm

```
    my $conf = PVE::QemuConfig->load_config($vmid);
    my $ostype = $conf->{ostype};

    if (defined(my $cipassword = $param->{cipassword})) {
        # Same logic as in cloud-init (but with the regex fixed...)
        if (!(PVE::QemuServer::windows_version($ostype))) {         #  If VM is Windows Then Ignore Hashing Password
            $param->{cipassword} = PVE::Tools::encrypt_pw($cipassword)
                if $cipassword !~ /^\$(?:[156]|2[ay])(\$.+){2}/;
        }    
    } 
```
