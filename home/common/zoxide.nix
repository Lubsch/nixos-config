{ config, pkgs, ... }:
let 
  j = pkgs.writeShellScriptBin "j" ''
    if [[ "$argv[1]" == "-"* ]]; then
        zx "$@"
    else
        cd "$@" 2> /dev/null || zx "$@"
    fi
  '';
in {
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = [ j ];

  home.persistence."/persist${config.home.homeDirectory}".directories = [ ".local/share/zoxide" ];
}
