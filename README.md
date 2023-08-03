# NixOS-config

This is my NixOS-config. It is heavily inspired by [Misterio77's config](https://git.sr.ht/~misterio/nix-config). One of its aims is staying below around 5000 lines of code.

## How it works

Host-configs and home-manager-configs are defined in flake.nix. Just specifiy the modules you'd like and the specialArguments to pass through to them.

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

This guide should include each and every step to get up and running on a new machine. This way, I don't have to put any effort into remembering a lot of details which you could get wrong. It also increases reproducibility. This is not primarily intended for other users but you can of course use and adapt these steps to your needs.

Download the iso from [https://nixos.org/download.html#nixos-iso](https://nixos.org/download.html#nixos-iso):

Burn the iso to an empty usb stick:
```
umount </dev/usb_drive>
doas dd if=</path/to/file.iso> of=</dev/usb_drive> status=progress
```

Boot from the USB drive and enable internet (preferably over ethernet).

To enable wifi:
```
sudo systemctl enable wpa_supplicant.service
wpa_cli
scan
add_network
set_network 0 ssid "<ssid>"
set_network 0 psk "<psk>"
enable_network 0
```

You can clone this repo or install it via ssh. Either way, run in this repo:
```
[sudo] ./install.sh <hostname> [<address>]
```
