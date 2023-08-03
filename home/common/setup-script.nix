{ pkgs, lib, config, ... }: 
let
  order-scripts = with builtins; scripts: order:
    if scripts == { } then order else let 
      newly-ordered = filter (n: scripts.${n}.deps == []) (attrNames scripts);
      deps-filtered = mapAttrs (_: s: s // { deps = filter (d: !(elem d order)) s.deps; }) scripts;
    in order-scripts (removeAttrs deps-filtered newly-ordered) (order ++ newly-ordered);
in {
  options.setup-scripts = lib.mkOption { };

  config = {
    setup-scripts.resume-offset = {
      deps = [ ];
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
            echo '${s} (dependencies: ${builtins.concatStringsSep " " deps}):'
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
