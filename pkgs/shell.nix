{ pkgs, inputs }:
pkgs.mkShell rec {
  shellHook = ''
    echo
    echo "  Available commands:"
    ${builtins.concatStringsSep "\n" (map (p: "echo ${p.name}") packages)}
    echo
  '';
  packages = with pkgs; [
    inputs.disko.packages.${pkgs.system}.disko
    (writeShellScriptBin "mount-disko" ''
      disko -m disko -f git+file:.#"$1"
    '')
    (let 
      config-template = ''
        HOSTNAME = [
          ./nixos/common
          {
            main-disk = "MAIN-DISK";
            swap-size = SWAPSIZE;
            home-manager.users.CHANGE.imports = [
              ./home/common
            ];
          }
        ];
      '';
    in writeShellScriptBin "generate-config" ''
      $1 || "Enter hostname as first argument!"
      set -e
      maindisk=$(lsblk --raw --noheadings --paths | awk '{print $1}' | ${pkgs.skim}/bin/sk --reverse --no-multi --preview='sudo fdisk -l {}' --preview-window='right:70%:wrap')
      read -p "Swap size in GB: " swapsize
      mkdir -p generated
      sudo nixos-generate-config --show-hardware-config --no-filesystems > generated/"$1"/hardware-configuration.nix
      echo '${config-template}' | sed -e "s|HOSTNAME|$1|" -e "s|MAINDISK|$maindisk|" -e "s|SWAPSIZE|$swapsize|" >> flake.nix
    '')
    (writeShellScriptBin "format-disko" ''
      $1 || "Enter hostname as first argument!"
      sudo disko -m disko -f git+file:.#"$1"
    '')
    (writeShellScriptBin "install-and-copy-repo" ''
      $1 || "Enter hostname as first and username as second argument!"
      $2 || "Enter username as second argument!"
      set -e
      sudo nixos-install --flake .#"$1" --no-root-password
      sudo mkdir -p /mnt/persist/home/"$2"/misc/repos
      sudo cp -r . /mnt/persist/home/"$2"/misc/repos/nixos-config
      sudo nixos-enter
      chown $username /persist/home/"$2"/misc -R
    '')
  ];
}
