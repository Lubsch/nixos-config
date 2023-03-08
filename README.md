# NixOS-config

This is my NixOS-config. It is heavily inspired by [Misterio77's config](https://git.sr.ht/~misterio/nix-config).

## How it works

Host-configs and home-manager-configs are defined in flake.nix. Just specifiy the modules you'd like and 

### Secrets

I decided on not managing secrets using nix, making bootsstrapping easier. Secret management (especially on such a small scale) should be seen as a stateful problem, when you think about it. Passwords are stored in `/persist/passwords/<username>`.

### SSH remote access

The file `./nixos-modules/common/user.nix` defines `openssh.authorizedKeys.keys`, which are the public keys of keypairs that can access the user over ssh. All ssh private keys are of course stored locally and always live on one device only (in the `~/.shh` folder, except for hostkeys)

### Colors

Color are managed using the module [nix-colors](https://github.com/Misterio77/nix-colors) which allows easy access to base16 colorschemes.

## Installation Guide

This guide should include each and every step to get up and running on a new machine. This way, I don't have to put any effort into remembering a lot of details which you could get wrong. It also increases reproducibility. This is not primarily intended for other users but you can of course use and adapt these steps to your needs.

### Prepare the USB drive

Download the [minimal iso](https://nixos.org/download.html#nixos-iso) and burn it to an empty usb-stick:
```
umount </dev/usb_drive>
doas dd if=</path/to/file.iso> of=</dev/usb_drive> status=progress
```

### Prepare the machine

Boot from the USB drive.

Change the keyboard layout:
```
sudo loadkeys de-latin1
```

Optionally, log in to a wireless network:
```
sudo systemctl start wpa_supplicant
wpa_cli
> add_network
> set_network 0 ssid "<ssid>"
> set_network 0 psk "<password>"
> enable_network 0
```
Clone the repository:
```
nix-shell -p git
git clone https://github.com/lubsch/nixos-config
cd nixos-config
```

### Run the setup script
```
cd scripts
sudo ./setup.sh <hostname> <drive> <username>
```
It will do the following:
- Partition your drive
- Format the ESP-partition and label it `/dev/disk/by-partlabel/ESP`
- Create luks-encryption on the encrypted-partition and label it `/dev/disk/by-partlabel/<hostname>_crypt`
- Prompt you to create an encryption password
- Format the BTRFS partition which will be accessible under `/dev/mapper/<hostname>`
- Create the BTRFS subvolumes, including the blank one
- Mount the BTRFS subvolumes and boot partition under `/mnt`
- Create the `/mnt/persist/var/log` directory
- Create the user password in `/persist/passwords/<username>`
- Enable nix command and nix flakes
- Store auto-generated hardware-config to `hardware-config.nix`

Modify the host's hardware-configuration on another device. Commit and push your changes to git.

On the new device run:
```
git pull
```

### Installation
Back on the new machine, pull the repo. Install NixOS to `/mnt`:
```
cd ..
sudo nixos-install --flake .#<hostname>
```
Shutdown and boot without the USB drive. Check if everything works, login as the user and install home-manager:
```
home-manager switch --flake .#"<username>@<hostname>"
```