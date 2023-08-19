{ pkgs, lib, config, ... }: 
let
  
  no-missing = with builtins; scripts:
    all (s: elem s (attrNames scripts)) (attrValues scripts)
    ||
    throw (toString (filter (s: !(elem s (attrNames scripts))) (attrValues scripts)));

  order-scripts = with builtins; scripts: order:
    if scripts == {} then order else let 
      only-unordered-deps = mapAttrs (_: s: s // { deps = filter (d: !(elem d order)) s.deps; }) scripts;
      dependencyless = filter (n: scripts.${n}.deps == []) (attrNames scripts);
    in 
    order-scripts (removeAttrs only-unordered-deps dependencyless) (order ++ dependencyless);
in {
  options.setup-scripts = lib.mkOption {};

  config = {
    # TODO
    setup-scripts.hardware = {
      deps = [ "git" ];
      script = ''
        doas btrfs inspect-internal map-swapfile -r /swap/swapfile | wl-copy
        echo Copied hardware-config to clipboard
        echo Press Enter to paste it into flake.nix
        read
        $EDITOR ~/misc/repos/nixos-config/flake.nix
      '';
    };

    home.packages = [
      (pkgs.writeShellScriptBin "setup-all" ''
        echo Starting setup
        ${builtins.concatStringsSep "\n" (builtins.map 
          (n: with config.setup-scripts.${n}; ''
            echo --------------------------------
            echo '${n} (dependencies: ${builtins.concatStringsSep " " deps}):'
            ${script}
            echo
            echo Press Enter to continue
            read
            echo
          '')
          (assert no-missing config.setup-scripts;
          order-scripts config.setup-scripts [])
        )}
      '')
    ];
  };
}
