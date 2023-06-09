# NixOS-config

This is my NixOS-config. It is heavily inspired by [Misterio77's config](https://git.sr.ht/~misterio/nix-config). One of its aims is staying below around 5000 lines of code.

## How it works

Host-configs and home-manager-configs are defined in flake.nix. Just specifiy the modules you'd like and the specialArguments to pass through to them.

## Dependencies

- Nixpkgs: Packages and standard library
- Impermanence: Define what data persist boots
- Hyprland: Window manager
- Home-Manager: Modules for managing the home directory
- Firefox-Addons: Duh.

## Where state lingers on

- Hibernation resume offset and swap size (see `flake.nix`)
- User password
- Wifi credentials
- SSH keys (including git access)
- Steam settings and Proton (run `, protonup` for install and updates)
- Some website settings
- Password Manager (required for email)

## Todo that's not marked

- Nixpak
    - Browser
    - Steam and games
- Nix-On-Droid
- E-Mail
- Calendar
- Statusbar

## Installation Guide

This guide should include each and every step to get up and running on a new machine. This way, I don't have to put any effort into remembering a lot of details which you could get wrong. It also increases reproducibility. This is not primarily intended for other users but you can of course use and adapt these steps to your needs.

Download the [minimal iso](https://nixos.org/download.html#nixos-iso) and burn it to an empty usb-stick:
```
umount </dev/usb_drive>
doas dd if=</path/to/file.iso> of=</dev/usb_drive> status=progress
```

Boot from the USB drive.

Enable wifi:
```
iwctl station <station> enable
iwctl station <station> connect <ssid>
```

Clone this repo:
```
clone
```
Run the setup script
```
doas setup <hostname> <drive> <username>
```
Install nixos to the machine
```
doas installate <hostname>
```
For recovery purposes you can also use these scripts:
```
doas decrypt <hostname>
```
```
doas mountall <hostname>
```
Shutdown and boot without the USB drive, enjoy! :)
