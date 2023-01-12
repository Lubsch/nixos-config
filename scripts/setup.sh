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
parted $2 set 1 esp on
parted $2 mkpart "$1_crypt" btrfs 513MiB 100%

sleep 0.2

# Create ESP file system
mkfs.vfat /dev/disk/by-partlabel/ESP

# Setup encryption and decrypt partition
cryptsetup --verify-passphrase -v luksFormat /dev/disk/by-partlabel/"$1_crypt"
cryptsetup open /dev/disk/by-partlabel/"$1_crypt" $1

# Create btrfs subvolumes and snapshot empty root subvolume
mkfs.btrfs /dev/mapper/$1
mount -t btrfs /dev/mapper/$1 /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/swap
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

# Unmount and close again (so the mount script can be used standalone)
umount /mnt
cryptsetup close $1

./mount-partitions.sh $1

# Create directory necessary for boot
mkdir -p /mnt/var/log

# Generate ssh-hostkeys
mkdir -p /mnt/etc/ssh
ssh-keygen -A -f /mnt -C "root@$1"

# Output host keys and auto generated config to magic-wormhole
echo -e "$(nixos-generate-config --root /mnt --show-hardware-config)" "\n" "$(cat /mnt/etc/ssh/ssh_host_ed25519_key.pub)" | wormhole send --text -
