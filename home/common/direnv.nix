{ lib, ... }: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      warn_timeout = "10m";
    };
  };

  home.sessionVariables.DIRENV_LOG_FORMAT = "";

  programs.zsh.initExtra = lib.mkAfter ''
    prompt_char() {
      if [ $DIRENV_FILE ]; then
          echo "> "
      else
          echo "$ "
      fi
    }
  '';

  persist.directories = [ 
    ".local/share/direnv"
  ];
}
