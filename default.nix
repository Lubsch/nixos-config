{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = [ pkgs.git (pkgs.callPackage ./home/nvim/package.nix {})];
  shellHook = ''
    set -eu
    mkdir -p ~/.config/nix
    echo "experimental-features nix-command flakes" > ~/.config/nix/nix.conf
    git clone https://github.com/lubsch/nixos-config
    cd nixos-config
    read -p "Enter hostname: " hostname
    generated="$(nixos-generate-config --show --no-filesystem)"
    
    config="$hostname = [ {\n"
    config+="  nixpkgs.hostPlatform = \"${builtins.currentSystem}\"\n"
    config+="  main-disk = \"/dev/CHANGE\"\n"
    config+="$(grep "updateMicrocode" <<< $generated)\n"
    config+="$(grep "boot.initrd.available" <<< $generated)\n"
    config+="$(grep "boot.kernel" <<< $generated)\n"
    config+="  home-manager.users.\"CHANGE\".imports = [\n"
    config+="    ./home/common\n"
    config+="  ];\n"
    config+="}\n"
    config+="  ./nixos/common\n"
    config+="];\n"
    nvim -c "let @+='$config'" flake.nix
    nix run --extra-experimental-features 'nix-command flakes' .#disko -- -m disko -f git+file:.#"$hostname"
    nixos-install --flake .#"$hostname" --no-root-password
  '';
}
