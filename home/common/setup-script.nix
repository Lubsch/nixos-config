{ pkgs, lib, config, ... }: 
let
  order-scripts = with builtins; scripts: order:
    if scripts == { } then order else let 
      newly-ordered = filter (n: scripts.${n}.dependencies == []) (attrNames scripts);
      dependencies-filtered = mapAttrs (_: s: s // { dependencies = filter (d: !(elem d order)) s.dependencies; }) scripts;
    in order-scripts
      (removeAttrs dependencies-filtered newly-ordered)
      (order ++ newly-ordered);
in {
  options.setup-scripts = lib.mkOption { };

  config = {
    setup-scripts.resume-offset = {
      dependencies = [ ];
      script = ''
        btrfs inspect-internal map-swapfile -r /swap/swapfile | wl-copy
        echo Copied offset to clipboard, paste it in the swap config in flake.nix
      '';
    };

    home.packages = [
      (pkgs.writeShellScriptBin "setup-all" ''
        echo Starting setup
        ${builtins.concatStringsSep "\n" (builtins.map 
          (s: with config.setup-scripts.${s}; ''
            echo ${s} (dependencies: ${builtins.concatStringsSep " " dependencies}):
            ${script}
            echo Press Enter to continue
            read
          '')
          (order-scripts config.setup-scripts [])
        )}
      '')
    ];
  };
}
