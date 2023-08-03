# NixOS-config

This is my NixOS-config. It takes inspiration from [Misterio77's config](https://git.sr.ht/~misterio/nix-config). One of its aims is limiting bloat. The flake also has my text-editor neovim as an output.

## How it works

System configs are defined in flake.nix. Specifiy the machines' modules and the specialArguments to pass to them.

## Dependencies

- Nixpkgs: Packages and standard library
- Impermanence: Define what data persist boots
- Home-Manager: Modules for managing the home directory
- Disko: Define partioning declaratively

## Where state lingers on outside scripts

- Desktop Wallpaper (set to `~/pictures/wallpaper`)
- Hibernation resume offset and swap size (see `flake.nix`)
- Wifi credentials
- SSH keys (including git access)
- Steam settings and Proton
- Some website settings

## Todo that's not marked

- Nixpak
    - Browser
    - Steam and games
- Nix-On-Droid
- E-Mail
- Calendar
- Statusbar
- Touch for terminal and image viewer
- Rotate button

## Installation Guide

This guide should include every step to setup a new machine, so I don't have to remember so many details one could get wrong. My config is primarily intended for my own use, but you can of course adapt it to your needs. :)

Download the iso from [https://nixos.org/download.html#nixos-iso](https://nixos.org/download.html#nixos-iso):

Burn the iso to an empty usb stick:
```
umount </dev/usb_drive>
doas dd if=</path/to/file.iso> of=</dev/usb_drive> status=progress
```

Boot from the USB drive and set the root password:
```
sudo passwd <password>
```

You need to enable an internet connection (preferably ethernet). To enable wifi:
```
sudo systemctl enable wpa_supplicant.service
wpa_cli
scan
add_network
set_network 0 ssid "<ssid>"
set_network 0 psk "<psk>"
enable_network 0
```

You can clone this repo or install it via ssh. Either way, run the script in this repo:
```
[sudo] ./install.sh <hostname> [<address>]
```
