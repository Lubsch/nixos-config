# NixOS-config

This is my NixOS-config.

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

- Readline for real
- Finish download-mover
- Modify vimium-c source default config (background/settings.ts)
- Debugger record script
- (Modify gtk(/its apps') source code)
- E-Mail
- Calendar
- Statusbar
- Backups
- Multiple drives
- Find solution for android
- Install loupe https://github.com/NixOS/nixpkgs/pull/247766

## Installation Guide

This guide should include every step to setup a new machine, so I don't have to remember too many details. This config is primarily intended for my own use, but you can adapt it to your needs, of course. :)

Download the iso from [https://nixos.org/download.html#nixos-iso](https://nixos.org/download.html#nixos-iso).

Burn the iso to an empty usb stick:
```
umount </dev/usb_drive>
doas dd if=</path/to/file.iso> of=</dev/usb_drive> status=progress
```

You need to connect to the internet (preferably over ethernet). To enable wifi:
```
iwctl station <station> scan
iwctl station <station> connect <ssid>
```

Clone and enter nix shell:
```
clone
```

Follow the instructions and reboot. After that, use `iwctl` to connect to wifi and do some manual setup:
```
setup-git
```
