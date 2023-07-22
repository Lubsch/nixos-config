{ pkgs, lib, config, ... }: 
let
  order-scripts = with builtins; scripts: order:
    if scripts == { } then order else let 
      new = filter (n: scripts.${n}.dependencies == []) (attrNames scripts);
    in order-scripts
      (removeAttrs (mapAttrs (_: s: s // { dependencies = filter (d: !(elem d order)) s.dependencies; }) scripts) new)
      (order ++ new);
in
{
  options.setup-scripts = lib.mkOption { };

  config.home.packages = [
    (pkgs.writeShellScriptBin "setup-all" ''
      echo Starting setup
      ${builtins.concatStringsSep "\n" (builtins.map 
        (s: with config.setup-scripts.${s}; ''
          # ${s} (dependencies: ${builtins.concatStringsSep " " dependencies }):
          ${script}
        '')
        (order-scripts config.setup-scripts [])
      )}
    '')
  ];
}
