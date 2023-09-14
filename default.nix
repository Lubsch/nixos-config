{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
  packages = with pkgs; [ 
    skim
    git 
    (writeShellScriptBin "install-script" ''
      read -p "Hostname: " hostname
      read -p "Username: " username
      disk=$(find /dev/disk/by-id/* | skim --reverse --preview "fdisk -l {}")

      generated="$(nixos-generate-config --show-hardware-config --no-filesystems)"
      echo "$hostname = [" >> flake.nix
      echo "  ./nixos/common" >> flake.nix
      echo "{" >> flake.nix
      echo "  nixpkgs.hostPlatform = \"${builtins.currentSystem}\";" >> flake.nix
      echo "  main-disk = \"$disk\";" >> flake.nix
      grep "updateMicrocode" <<< "$generated" >> flake.nix
      grep "boot.initrd.available" <<< "$generated" >> flake.nix
      grep "boot.kernel" <<< "$generated" >> flake.nix
      echo "  home-manager.users.\"$username\".imports = [" >> flake.nix
      echo "    ./home/common" >> flake.nix
      echo "  ];" >> flake.nix
      echo "} ];" >> flake.nix

      vim flake.nix

      disko -m disko -f git+file:.#"$hostname"
      nixos-install --flake .#"$hostname" --no-root-password

      mkdir -p /mnt/persist/home/"$username"/misc/repos
      cp -r . /mnt/persist/home/"$username"/misc/repos/nixos-config
    '')
  ];
  #shellHook = ''
    #read -p "Hostname: " hostname
    #read -p "Username: " username
    #disk=$(find /dev/disk/by-id/* | skim --reverse --preview "fdisk -l {}")
#
    #generated="$(nixos-generate-config --show-hardware-config --no-filesystems)"
    #echo "$hostname = [" >> flake.nix
    #echo "  ./nixos/common" >> flake.nix
    #echo "{" >> flake.nix
    #echo "  nixpkgs.hostPlatform = \"${builtins.currentSystem}\";" >> flake.nix
    #echo "  main-disk = \"$disk\";" >> flake.nix
    #grep "updateMicrocode" <<< "$generated" >> flake.nix
    #grep "boot.initrd.available" <<< "$generated" >> flake.nix
    #grep "boot.kernel" <<< "$generated" >> flake.nix
    #echo "  home-manager.users.\"$username\".imports = [" >> flake.nix
    #echo "    ./home/common" >> flake.nix
    #echo "  ];" >> flake.nix
    #echo "} ];" >> flake.nix
#
    #vim flake.nix
#
    #nix run .#disko -- -m disko -f git+file:.#"$hostname"
    #nixos-install --flake .#"$hostname" --no-root-password
#
    #mkdir -p /mnt/persist/home/"$username"/misc/repos
    #cp -r . /mnt/persist/home/"$username"/misc/repos/nixos-config
    #nix shell .#disko
  #'';
}
