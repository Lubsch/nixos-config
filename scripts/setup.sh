#!/bin/sh

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

# I hate shell scripting
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

# Remount so that the scripts are confirmed working
./umount-partitions.sh "$1"
./mount-partitions.sh "$1"

# Create directory necessary for boot
mkdir -p /mnt/var/log

# Create the user password
mkdir -p /mnt/persist/passwords
mkpasswd -m sha-512 > /mnt/persist/passwords/"$3"

# Enable nix command and flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# Print out auto-generated hardware config
nixos-generate-config --root /mnt --show-hardware-config
