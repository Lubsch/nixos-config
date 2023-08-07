{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  packages = [ pkgs.git ];
  shellHook = ''
    rm -rf nixos-config
    git clone https://github.com/lubsch/nixos-config
    cd nixos-config
    read -p "Enter hostname: " hostname
    nix run --extra-experimental-features 'nix-command flakes' .#disko -- -m disko -f git+file:.#"$hostname"
    nixos-install --flake .#$"hostname" --no-root-password
  '';
}
