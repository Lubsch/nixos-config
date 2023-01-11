#!/bin/sh

# Exit on error
set -e

# Exit when argument count is wrong
if [ "$#" -ne 2 ]; then
    echo "./setup.sh <hostname> <drive_device>"
    exit 1
fi

# Partition the drive
parted $2 mklabel gpt
parted $2 mkpart ESP fat32 1MiB 513MiB
parted $2 set ESP esp on
parted $2 mkpart $1_crypt btrfs 513MB 100%

# Create ESP file system
mkfs.vfat /dev/disk/by-partlabel/ESP

# Setup encryption and temporarily unencrypt
cryptsetup --verify-passphrase -v luksFormat /dev/disk/by-partlabel/$1_crypt
cryptsetup open /dev/disk/by-partlabel/$1_crypt enc
mkfs.btrfs /dev/mapper/enc

# Create subvolumes and snapshot empty root subvolume
mkdir /btrfs
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
mkdir /mnt/persist
mount -o subvol=root,compress=zstd,noatime /dev/mapper/enc /mnt/persist
mkdir /mnt/swap
mount -o subvol=root,noatime /dev/mapper/enc /mnt/swap
mkdir /mnt/boot
mount /dev/disk/by-label/ESP /mnt/boot

# Generate ssh-hostkeys
mkdir -p /mnt/etc/ssh
ssh-keygen -A -f /mnt -C "root@$1"

# Output host keys and auto generated config to magic-wormhole
printf "%s\n%s" "$(nixos-generate-config --root /mnt --show-hardware-config)" "$(cat /mnt/etc/ssh/ssh_host_ed25519_key.pub)" | wormhole send
