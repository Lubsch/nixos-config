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
            main-disk = "MAINDISK";
            swap-size = SWAPSIZE;
            home-manager.users.CHANGE.imports = [
              ./home/common
            ];
          }
        ];
      '';
    in writeShellScriptBin "generate-config" ''
      if [ ! $1 ]; then
        echo "Enter hostname as first argument!"
        exit 1
      fi
      set -e
      maindisk=$(lsblk --raw --noheadings --paths | awk '{print $1}' | ${pkgs.skim}/bin/sk --reverse --no-multi --preview='sudo fdisk -l {}' --preview-window='right:70%:wrap')
      read -p "Swap size in GB: " swapsize
      mkdir -p generated
      sudo nixos-generate-config --show-hardware-config --no-filesystems > generated/"$1".nix
      echo '${config-template}' | sed -e "s|HOSTNAME|$1|" -e "s|MAINDISK|$maindisk|" -e "s|SWAPSIZE|$swapsize|" >> flake.nix
      vim flake.nix
    '')
  ];
}
