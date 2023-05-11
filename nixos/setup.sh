#!/bin/sh

# TODO make these scripts work for non-impermanence and non-encryption, too

# Exit on error
set -e

# Exit when argument count is wrong
if [ "$#" -ne 3 ]; then
    echo "./setup.sh <hostname> <drive_device> <username>"
    exit 1
fi

# Partition the drive
parted "$2" mklabel gpt
parted "$2" mkpart ESP fat32 1MiB 513MiB
parted "$2" set 1 esp on
parted "$2" mkpart "$1_crypt" btrfs 513MiB 100%

# Would otherwise fail for some reason
sleep 0.2

# Create ESP file system
mkfs.vfat /dev/disk/by-partlabel/ESP

# Setup encryption and decrypt partition
cryptsetup --verify-passphrase -v luksFormat /dev/disk/by-partlabel/"$1_crypt"
cryptsetup open /dev/disk/by-partlabel/"$1_crypt" "$1"

# Create btrfs subvolumes and snapshot empty root subvolume
mkfs.btrfs /dev/mapper/"$1"
mount -t btrfs /dev/mapper/"$1" /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/swap
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

umount /mnt

mount -o subvol=root,compress=zstd,noatime /dev/mapper/"$1" /mnt
mkdir -p /mnt/nix
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/"$1" /mnt/nix
mkdir -p /mnt/persist
mount -o subvol=persist,compress=zstd,noatime /dev/mapper/"$1" /mnt/persist
mkdir -p /mnt/swap
mount -o subvol=swap,noatime /dev/mapper/"$1" /mnt/swap
mkdir -p /mnt/boot
mount /dev/disk/by-partlabel/ESP /mnt/boot

# Create home directory with permissions
mkdir -p /mnt/persist/home/"$3"
chown "$3" /mnt/persist/home/"$3"

# Create the user password
mkdir /mnt/persist/passwords
mkpasswd -m sha-512 > /mnt/persist/passwords/"$3"

# Enable nix command and flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# Store auto-generated hardware config
nixos-generate-config --root /mnt --show-hardware-config > hardware-config.nix