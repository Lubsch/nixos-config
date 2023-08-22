{ pkgs ?
 let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
  import nixpkgs {}
}:
pkgs.mkShell {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
  packages = with pkgs; [ 
    git 
    (callPackage ./home/nvim/package.nix { lsp = false; })
  ];
  shellHook = ''
    rm -rf nixos-config-install
    git clone https://github.com/lubsch/nixos-config nixos-config-install
    cd nixos-config-install

    read -p "Hostname: " hostname
    read -p "Username: " username

    generated="$(sudo nixos-generate-config --show-hardware-config --no-filesystems || doas nixos-generate-config --show-hardware-config --no-filesystems)"
    echo "$hostname = [" >> flake.nix
    echo "  ./nixos/common" >> flake.nix
    echo "{" >> flake.nix
    echo "  nixpkgs.hostPlatform = \"${builtins.currentSystem}\";" >> flake.nix
    echo "  main-disk = \"/dev/CHANGE\";" >> flake.nix
    grep "updateMicrocode" <<< "$generated" >> flake.nix
    grep "boot.initrd.available" <<< "$generated" >> flake.nix
    grep "boot.kernel" <<< "$generated" >> flake.nix
    echo "  home-manager.users.\"$username\".imports = [" >> flake.nix
    echo "    ./home/common" >> flake.nix
    echo "  ];" >> flake.nix
    echo "} ];" >> flake.nix

    nvim flake.nix

    nix run .#disko -- -m disko -f git+file:.#"$hostname"
    nixos-install --flake .#"$hostname" --no-root-password

    mkdir -p /mnt/persist/home/"$username"/misc/repos
    cp -r . /mnt/persist/home/"$username"/misc/repos/nixos-config
  '';
}
