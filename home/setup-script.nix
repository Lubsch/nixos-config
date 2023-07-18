{ pkgs, lib, config, ... }: {
  options.setup-scripts = lib.mkOption { };

  config = {
    home.packages = [(pkgs.writeShellScriptBin "setup-all" ''
        echo Starting setup
        ${builtins.concatStringsSep "\n" (builtins.map 
          (s: ''
            read -p "Setup ${s.name}? [y/n]: " a; [ $a = "y" ] && {
              ${s.script}
            }
          '') 
          config.setup-scripts
        )}
    '')];
  };
}
