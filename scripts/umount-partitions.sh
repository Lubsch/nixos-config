#!/bin/sh

# Exit when argument count is wrong
if [ "$#" -ne 1 ]; then
    echo "./umount-partitions.sh <hostname>"
    exit 1
fi

umount /mnt/nix
umount /mnt/persist
umount /mnt/swap
umount /mnt/boot
umount /mnt

cryptsetup close "$1"
