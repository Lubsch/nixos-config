#!/bin/sh

set -e

if [ "$#" -ne 3 ]; then
    echo "USAGE: ./install.sh <hostname> <address> <is-arm>"
    exit 1
fi

temp=$(mktemp -d)

cleanup() {
    rm -rf "$temp"
    rm -rf /tmp/nix
    rm -rf /tmp/luks.key
}
trap cleanup EXIT

# Install nix from the internet so it truly works on any machine
curl -L https://hydra.nixos.org/job/nix/maintenance-2.17/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist > /tmp/nix
chmod +x /tmp/nix

if [ "$3" = "false" ]; then
    armFlag=
elif [ "$3" = "true" ]; then
    armFlag="--kexec '$(./nix build --print-out-paths github:nix-community/nixos-images#packages.aarch64-linux.kexec-installer-nixos-unstable-noninteractive)/nixos-kexec-installer-noninteractive-aarch64-linux.tar.gz'"
else
    echo "USAGE: ./install.sh <hostname> <address> <is-arm>"
    echo "<is-arm> needs to be true or false"
    exit 1
fi

stty -echo
printf "Enter disk encryption password: "
read -r password
echo $password > /tmp/luks.key
stty echo

users=$(nix eval --raw .#nixosConfigurations."$1"._module.specialArgs.users --apply 'users: builtins.concatStringsSep "\n" (builtins.attrNames users)')
for user in $users; do
    mkdir -p "$temp"/persist/passwords
    chmod o=,g= "$temp"/persist/passwords
    echo Enter password for "$user":
    mkpasswd -m sha-512 > "$temp"/persist/passwords/"$user"
done

# key-path twice, once remote, once local
/tmp/nix run github:numtide/nixos-anywhere -- $armFlag --extra-files "$temp" --disk-encryption-keys /tmp/luks.key /tmp/luks.key --flake .#"$1" root@"$2"
