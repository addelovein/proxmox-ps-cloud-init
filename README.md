# Proxmox Cloud-Init in Powershell

## Looking for Help!
I am no Powershell genious, however i started this project due to the lack of a simple Sysprep/Proxmox/cloud-init way. There are existing however none that focuses soulely on proxmox and there for the projects become to complex.

So Are you a Poweradmin/user and see ways to make this better just Forl and give us a PR. (Please document if needed)

## Introduction
Proxox uses Cloud-init for setting up VMSs. However there is no support for windows.
This is a 100% powershell version that will setup the Hostname (Computer-Name), install SSH keys for OpenSSH if available.

## Installation
Place all files from repo in c:\cloud-init

**Quick Setup**
```
Download package: . { iwr -useb https://t.ly/5kgtP } | iex;
To Start Sysprep: c:\cloud-init\install
```

## Usage
Powershell scripts placed in the folders **system** or **user** will be run if the file name starts with a numeric value.
The files will be run in the numeric order given.
If the filename ends with **ALWAYS.ps1** it will be run everytime the computer starts using ScheduledTasks. Otherwise it will only be run firsttime.
Scripts in system are run by the **SYSTEM** user prelogin.
Scripts placed in **USER** will be run on login by user.

## Implemented functions
* **Right now only fixed IP or None Supported**
* Setup IP
* Setup Gateway
* Setup Subnetmask
* Setup SSH Keys
* Extend Disk

## Todo
* Optimize (I am no Powershell Guru so any help is appreciated)
* Fix if user wants DHCP
* A Network required section So the script will check for network connection if its found it will run a cloud-init.network.ps1
* Multiple Network Adapters

## Missing functions
Admin user setup with password is missing this is Due to proxmox suppliyng the password in a SHA hash where Windows would need it in cleartext.
Because of this when machine installs first time it will Ask for Administrator Password. 


(I do not recomend this therefor I have disabled all functions that rely on this... )
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
