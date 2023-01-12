#!/bin/sh

# Exit when argument count is wrong
if [ "$#" -ne 1 ]; then
    echo "./mount-partitions.sh <hostname>"
    exit 1
fi

# Decrypt partition
cryptsetup open /dev/disk/by-partlabel/"$1_crypt" $1

# Mount subolumes with right options
mount -o subvol=root,compress=zstd,noatime /dev/mapper/$1 /mnt
mkdir -p /mnt/nix
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/$1 /mnt/nix
mkdir -p /mnt/persist
mount -o subvol=persist,compress=zstd,noatime /dev/mapper/$1 /mnt/persist
mkdir -p /mnt/swap
mount -o subvol=swap,noatime /dev/mapper/$1 /mnt/swap
mkdir -p /mnt/boot
mount /dev/disk/by-partlabel/ESP /mnt/boot
