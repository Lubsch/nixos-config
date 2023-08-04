#!/bin/sh

set -e

if [ "$#" -gt 2 ] || [ "$#" -lt 1 ]; then
    echo "USAGE: ./install.sh <hostname [<address>]"
    exit 1
fi

if [ "$2" != "" ]; then
    rsync --rsh="ssh -o StrictHostKeyChecking=no" -r . root@"$2":nixos-config --progress
    ssh -o StrictHostKeyChecking=no root@"$2" -t "cd nixos-config && ./install.sh $1"
    exit
fi

echo "About to format the disks on $(hostnamectl hostname) (Type 'Yes')"
read -r answer
[ "$answer" = "Yes" ] || exit
nix run .#disko -- -m disko -f git+file:.#"$1"

nixos-install --flake .#"$1" --no-root-password

users=$(nix eval --raw .#nixosConfigurations."$1"._module.specialArgs.users --apply 'users: builtins.concatStringsSep "\n" (builtins.attrNames users)')

nixos-enter
for user in $users; do
    mkdir -p /persist/home/"$user"
    chown "$user" /persist/home/"$user"
    mkdir -p /persist/passwords
    chmod o=,g= /persist/passwords
    echo Enter password for "$user":
    mkpasswd -m sha-512 > /persist/passwords/"$user"
done

reboot
