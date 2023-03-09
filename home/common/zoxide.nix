{ config, pkgs, ... }: {

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh.initExtra = ''
    function j() {
        if [[ "$argv[1]" == "-"* ]]; then
            z "$@"
        else
            cd "$@" 2> /dev/null || z "$@"
        fi
    }
  '';

  home.persistence."/persist${config.home.homeDirectory}".directories = [ ".local/share/zoxide" ];
}
