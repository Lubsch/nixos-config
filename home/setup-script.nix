{ pkgs, config, ... }: 
let
in {
  home.packages = [
    # TODO
    (pkgs.writeShellScriptBin "setup-swap" ''
      # deps git
      echo "  swap = { size = CHANGE; offset = \"$(doas btrfs inspect-internal map-swapfile -r /swap/swapfile)\"; }" | wl-copy
      echo Copied swap-config to clipboard
      echo Press Enter, then paste it into flake.nix
      read
      $EDITOR ~/misc/repos/nixos-config/flake.nix
    '')
   #(pkgs.writeShellScriptBin "setup-all" ''
   #  echo Starting setup
   #  ${builtins.concatStringsSep "\n" (builtins.map 
   #    (n: with config.setup-scripts.${n}; ''
   #      echo --------------------------------
   #      echo '${n} (dependencies: ${builtins.concatStringsSep " " deps}):'
   #      ${script}
   #      echo
   #      echo Press Enter to continue
   #      read
   #      echo
   #    '')
   #    (assert no-missing config.setup-scripts;
   #    order-scripts config.setup-scripts [])
   #  )}
   #'')
  ];
}
