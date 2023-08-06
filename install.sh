#!/bin/sh

mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
nix-shell -p git
git clone https://github.com/lubsch/nixos-config
cd nixos-config
sudo nix run .#disko -- -m disko -f git+file:.#"$1"
sudo nixos-install --flake .#"$1" --no-root-password
