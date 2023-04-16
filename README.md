# NixOS-config

This is my NixOS-config. It is heavily inspired by [Misterio77's config](https://git.sr.ht/~misterio/nix-config). One of its aims is staying below around 5000 lines of code.

## How it works

Host-configs and home-manager-configs are defined in flake.nix. Just specifiy the modules you'd like and the specialArguments to pass through to them.

## Dependencies

- Nixpkgs: Perhaps the greatest package repository out there, also providing NixOS-modules and a library
- Home-Manager: Modules for managing the home directory
- Impermanence: Define what data persist boots

## Where state lingers on

- Hibernation resume offset and swap size (see `flake.nix`)
- Wifi and Email credentials
- SSH keys (and GitHub access)
- Steam settings and Proton (just run `, protonup`)
- Browser settings
- User password

## Todo that's not marked

- Background
- Nixpak
    - Browser
    - Steam and games
- Nix-On-Droid
- E-Mail
- PDF and image viewing
- Templates

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
- Create the user password in `/persist/passwords/<username>`
- Enable nix command and nix flakes
- Put auto-generated hardware-config into `hardware-config.nix`

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
Shutdown and boot without the USB drive, enjoy! :)
