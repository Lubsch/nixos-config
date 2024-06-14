# NixOS-config

This is my NixOS-config.

## Features:

- Hosts are only customized in `flake.nix`
- Complexity is avoided where possible
- Impermanence using BTRFS (`/` is wiped on every reboot)
- Customized neovim as a flake output
- Home setup scripts (to configure email and git)

## Dependencies

- Nixpkgs: Packages and standard library
- Impermanence: To define what data persists boots
- Home-Manager: Modules for managing the home environment
- Disko: To define partitions declaratively

## Where state lingers on

- Desktop Wallpaper (set to `~/pictures/wallpapers/current`)
- Wifi credentials
- Steam settings and games
- Website settings
- Currently: browser settings

## Unmarked Todo

- Move from special workspaces to something more practical (floating tags)
- Shutdown before battery is empty
- Backups
- (Modify gtk(/its apps') source code)
- E-Mail
- Calendar
- Statusbar (https://github.com/JakeStanger/ironbar)
- Multiple drives
- Maybe make it runnable on android, too

## Installation Guide

This guide should include every step to setup a new machine. This config is primarily intended for my own use, but you can of course adapt it to your own needs. :)

Download the iso from [https://nixos.org/download.html#nixos-iso](https://nixos.org/download.html#nixos-iso).

Burn the iso to an empty usb stick:
```
umount </dev/usb_drive>
sudo dd if=</path/to/file.iso> of=</dev/usb_drive> status=progress
```

An internet connection is required. These commands configure wifi:
```
iwctl station <station> scan
iwctl station <station> connect <ssid>
```

Clone and enter nix shell:
```
clone
```

Follow the instructions and reboot. Then, use `iwctl` to connect to wifi and do some manual setup:
```
setup-git
```
