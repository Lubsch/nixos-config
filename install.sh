#!/bin/sh

set -e

mount="false"
iso="false"
hostname=""
address=""

print_usage() {
    echo "USAGE:"
    echo "  ./install.sh [OPTIONS]"
    echo
    echo "OPIONS:"
    echo "  -m  Only mount the drive"
    echo "  -i  Create an install iso"
    echo "  -h  Hostname of device"
    echo "  -a  Address to reach device"
    exit 1
}

while getopts 'mih:a:' flag; do
    case "${flag}" in
        m) mount="true" ;;
        i) iso="true" ;;
        h) hostname="${OPTARG}" ;;
        h) address="${OPTARG}" ;;
        *) print_usage ;;
    esac
done


files=$(mktemp -d)
temp=$(mktemp -d)
cleanup() {
    rm -rf "$temp"
    rm -rf "$files"
}
trap cleanup EXIT

# Install nix if it doesn't exist
# curl -L https://hydra.nixos.org/job/nix/maintenance-2.17/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist > /tmp/nix
# chmod +x /tmp/nix
nix="nix"

system=$($nix eval --raw .#nixosConfigurations."$hostname".pkgs.system)

createiso () {
    $nix run github:nix-community/nixos-generators -- -f install-iso -c ./nixos/install-iso.nix -I nixpkgs="$($nix eval --raw .#inputs.nixpkgs.outPath)"
}

mountdrives () {
    echo asdf
}

installhost () {
    if [ "$system" = "x86_64-linux" ]; then
        kexecFlag=
    else
        kexecFlag="--kexec '$($nix build --print-out-paths github:nix-community/nixos-images#packages."$system".kexec-installer-nixos-unstable-noninteractive)/nixos-kexec-installer-noninteractive-"$system".tar.gz'" || (echo "System ${system} is not supported. It must be x86_64-linux or aarch64-linux.";  exit 1)
    fi

    stty -echo
    printf "Enter disk encryption password: "
    read -r password
    echo -n $password > "$temp"/luks.key
    stty echo

    users=$($nix eval --raw .#nixosConfigurations."$hostname"._module.specialArgs.users --apply 'users: builtins.concatStringsSep "\n" (builtins.attrNames users)')
    for user in $users; do
        mkdir -p "$files"/persist/passwords
        chmod o=,g= "$files"/persist/passwords
        echo Enter password for "$user":
        mkpasswd -m sha-512 > "$files"/persist/passwords/"$user"
    done

    # key-path twice, once remote, once local
    $nix run github:numtide/nixos-anywhere -- $kexecFlag --extra-files "$files" --disk-encryption-keys "$temp"/luks.key "$temp"/luks.key --flake .#"$hostname" root@"$address"
}
