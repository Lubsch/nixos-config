{ pkgs, ... }: {

  config = {
    home.packages = [(pkgs.writeShellScriptBin "setup-all" ''
        echo Starting setup
        echo WARNING: About to show arbitrary programs starting with "setup-"

        for  f
        read -p "Setup  [y/n]: " a; [ $a = "y" ] && {
    '')];
  };
}
