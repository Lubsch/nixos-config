# NixOS-config

This is my NixOS-config. It takes some inspiration from [Misterio77's config](https://git.sr.ht/~misterio/nix-config).

## Features:

- Hosts are only customized in ´flake.nix´
- Not too bloated
- Impermanence (`/` is wiped on every reboot) using BTRFS
- Home setup scripts (email from password manager and more)
- Customized neovim as a flake output

## Dependencies

- Nixpkgs: Packages and standard library
- Impermanence: Define what data persist boots
- Home-Manager: Modules for managing the home directory
- Disko: Define partitions declaratively

## Where state lingers on outside scripts

- Desktop Wallpaper (set to `~/pictures/wallpapers/current`)
- Hibernation resume offset and swap size (see `flake.nix`)
- Wifi credentials
- Steam settings and games
- Website settings

## Todo that's not marked

- Make qutebrowser not create `~\.pki`
- Setup usable Debugger
- Fix Nix-On-Droid rebuilds
- E-Mail
- Calendar
- Statusbar
- Touch for terminal and image viewer
    - works in foot but hyprland doesn't make cursor disappear when using touch

## Installation Guide

This guide should include every step to setup a new machine, so I don't have to remember so many details one could get wrong. My config is intended for my own use, but you can of course adapt it to your needs. :)

Download the iso from [https://nixos.org/download.html#nixos-iso](https://nixos.org/download.html#nixos-iso):

Burn the iso to an empty usb stick:
```
umount </dev/usb_drive>
doas dd if=</path/to/file.iso> of=</dev/usb_drive> status=progress
```

Installer Layout:
```
sudo loadkeys de-latin1
```

You need to connect to the internet (preferably over ethernet). To enable wifi:
```
sudo systemctl enable wpa_supplicant.service
wpa_cli
scan
add_network
set_network 0 ssid "<ssid>"
set_network 0 psk "<psk>"
enable_network 0
```

Format and install:
```
sudo nix-shell https://github.com/lubsch/nixos-config/archive/main.zip
```
