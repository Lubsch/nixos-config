{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = [ pkgs.git ];
  shellHook = ''
    set -eu
    rm -rf nixos-config-for-installer
    git clone https://github.com/lubsch/nixos-config nixos-config-for-installer
    cd nixos-config-for-installer
    read -p "Enter hostname: " hostname
    nix run --extra-experimental-features 'nix-command flakes' .#disko -- -m disko -f git+file:.#"$hostname"
    nixos-install --flake .#"$hostname" --no-root-password
    rm -rf nixos-config-for-installer
  '';
}
