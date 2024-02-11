# Proxmox Cloud-Init in Powershell

## Introducktion
Proxox uses Cloud-init for setting up VMSs. However there is no support for windows.
This is a 100% powershell version that will setup the Hostname (Computer-Name), install SSH keys for OpenSSH if available.

## Implemented functions
* Setup IP
* Setup Gateway
* Setup Subnetmask
* Setup SSH Keys
* Extend Disk

## Missing functions
Admin user setup with password is missing this is Due to proxmox suppliyng the password in a SHA hash where Windows would need it in cleartext.

This has made us disable all scripts that depend on running as User and not system.
