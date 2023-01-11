#!/bin/sh

# Exit on error
set -e

# Exit when argument count is wrong
if [ "$#" -ne 3 ]; then
    echo "./setup.sh <hostname> <ESP-partition> <encrypted-partition>"
    exit 1
fi

# Create ESP file system
mkfs.vfat -n ESP "$2"

# Setup encryption and temporarily unencrypt
cryptsetup --verify-passphrase -v luksFormat "$3" --label "$1"_crypt
cryptsetup open "$3" enc
mkfs.btrfs /dev/mapper/enc

# Create subvolumes and snapshot empty root subvolume
mount -t btrfs /dev/mapper/enc /btrfs
btrfs subvolume create /btrfs/root
btrfs subvolume create /btrfs/nix
btrfs subvolume create /btrfs/persist
btrfs subvolume create /btrfs/swap
btrfs subvolume snapshot -r /btrfs/root /btrfs/root-blank
umount /btrfs

# Mount subolumes with right options
mount -o subvol=root,compress=zstd,noatime /dev/mapper/enc /mnt
mkdir /mnt/nix
mount -o subvol=root,compress=zstd,noatime /dev/mapper/enc /mnt/nix
mkdir /mnt/nix
mount -o subvol=root,compress=zstd,noatime /dev/mapper/enc /mnt/persist
mkdir /mnt/nix
mount -o subvol=root,noatime /dev/mapper/enc /mnt/swap
mkdir /mnt/boot
mount /dev/disk/by-label/ESP /mnt/boot

# Generate ssh-hostkeys
mkdir -p /mnt/etc/ssh
ssh-keygen -A -f /mnt -C "root@$1"

# Output host keys and auto generated config to magic-wormhole
printf "%s\n%s" "$(nixos-generate-config --root /mnt --show-hardware-config)" "$(cat /mnt/etc/ssh)" | wormhole send
