# NixOS-config

This is my NixOS-config. It is heavily inspired by [Misterio77's config](https://git.sr.ht/~misterio/nix-config).

## How it works

### Secrets
- Each host has its own private hostkey, saved in `/persist/etc/ssh/ssh_host_ed25519_key` (as configured in `./hosts/common/global/openssh.nix`)
- This hostkey is used to decrypt secrets (such as user and wifi passwords) stored in `./hosts/common/global/secrets.yaml` (as configured in `./hosts/common/global/sops.nix`)
- GPG/PGP is avoided

### SSH remote access
- The file `./hosts/common/users/lubsch.nix` defines `openssh.authorizedKeys.keys`, which are the public ssh keys of keypairs that can access the lubsch user over ssh
- All ssh private keys are of course stored locally and always live on one device only (in the `~/.shh` folder, except for hostkeys)

### Colors
- Color are managed using the module [nix-colors](https://github.com/Misterio77/nix-color) which allows easy access to base16 colorschemes

## Installation Guide

This guide should include each and every step to get up and running on a new machine. This way, I don't have to put any effort into remembering a lot of details which you could get wrong. It also increases reproducibility. This is not primarily intended for other users but you can of course use and adapt these steps to your needs.

### Prepare the USB drive
- Build the install-iso using the command:
    ```nix build .#install-iso```
- Burn the ISO to a USB drive (unmounted and e.g. `sdc instead of sdc1`) using the following command which will show the progress:
    ```doas dd if=./result/iso/*.iso of=/dev/<usb_drive> status=progress```

### Prepare the machine
-  Boot from the USB drive and (optionally) login to a wireless network using `nmtui`
-  Partitioning (THIS STEP CAN CAUSE IRREVERSIBLE DATA-LOSS AND SHOULD BE DONE WITH GREAT CARE, DON'T JUST COPY AND PASTE COMMANDS YOU DON'T UNDERSTAND!):
    - Start fdisk: `sudo fdisk /dev/<drive>`
    - Create the ESP-partition with an offset of `+500M` and has the type `EFI System`
    - Create the encrypted filesystem partition which fills the rest of the drive with the type `Linux filesystem`

### Run the setup script
- Clone the repository into `~` using the command:
    ```git clone https://github.com/Lubsch/nixos-config```
- Execute the script:
    ```./setup.sh <hostname> /dev/<ESP-partition> /dev/<encrypted-partition>```
- It will do the following:
    - Format the ESP-partition and label it `/dev/disk/by-label/ESP`
    - Create luks-encryption on the encrypted-partition and label it `/dev/disk/by-label/<hostname>_crypt`
    - Prompt you to create an encryption password
    - Format the BTRFS partition which will be accessible under `/dev/disk/by-label/duke`
    - Create the BTRFS subvolumes
    - Mount the BTRFS subvolumes and boot partition under `/mnt`
    - Generate an ssh-hostkey and put it in the `/mnt/persist/etc/ssh` directory
    - Generate `system-info.nix` which contains the auto-generated hardware-configuration and the public ssh-hostkey
- Copy the file using the command `wormhole send system-info.nix`
- On another computer with access to this repo, use `wormhole receive`, add the key to `./hosts/common/secrets.yaml` and modify the hosts hardware-configuration in `./hosts/<hostname>/default.nix`
- Commit and push your changes to git

### Installation
- Back on the new machine, do a `git pull`
- Verify that you can edit `./hosts/common/global/secrets.yml`
- Run the following command:
    ```nixos-install --flake .#<hostname>```
- Shutdown and boot without the USB drive
- Check if everything works, login as the user and install home-manager:
    ```home-manager switch --flake .#lubsch@<hostname>```
- Have fun :)
