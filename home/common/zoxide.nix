{ config, ... }: {

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh.initExtra = ''
    function j() {
        if [[ "$argv[1]" == "-"* ]]; then
            __zoxide_z "$@"
        else
            cd "$@" 2> /dev/null || __zoxide_z "$@"
        fi
    }
  '';

  home.persistence."/persist${config.home.homeDirectory}".directories = [
    ".local/share/zoxide" 
  ];
}
