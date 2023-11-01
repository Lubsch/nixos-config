{ pkgs, inputs }:
pkgs.mkShell {
  packages = with pkgs; [
    inputs.disko.packages.${pkgs.system}.disko
    (writeShellScriptBin "mount-disko" ''
      read -p "Hostname: " hostname
      disko -m disko -f git+file:.#"$hostname"
    '')
    (writeShellScriptBin "format-and-install" ''
      read -p "Hostname: " hostname
      read -p "Username: " username
      sudo fdisk -l
      echo
      echo Remember correct main-disk\!
      read
      generated="$(nixos-generate-config --show-hardware-config --no-filesystems)"
      echo "$hostname = [" >> flake.nix
      echo "  ./nixos/common" >> flake.nix
      echo "{" >> flake.nix
      echo "  nixpkgs.hostPlatform = \"${pkgs.system}\";" >> flake.nix
      echo "  main-disk = \"CHANGE\";" >> flake.nix
      echo "  swap.size = \"CHANGE\";" >> flake.nix
      grep "updateMicrocode" <<< "$generated" >> flake.nix
      grep "boot.initrd.available" <<< "$generated" >> flake.nix
      grep "boot.kernel" <<< "$generated" >> flake.nix
      echo "  home-manager.users.\"$username\".imports = [" >> flake.nix
      echo "    ./home/common" >> flake.nix
      echo "  ];" >> flake.nix
      echo "} ];" >> flake.nix
      vim flake.nix
      sudo disko -m disko -f git+file:.#"$hostname"
      sudo nixos-install --flake .#"$hostname" --no-root-password
      sudo mkdir -p /mnt/persist/home/"$username"/misc/repos
      sudo cp -r . /mnt/persist/home/"$username"/misc/repos/nixos-config
      sudo nixos-enter
      chown $username /persist/home/"$username"/misc -R
    '')
  ];
}
