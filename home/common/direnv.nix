{ lib, config, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      warn_timeout = "10m";
    };
  };

  programs.zsh = {
    shellAliases.da = "direnv allow";
    shellAliases.de = "echo use flake > .envrc";
    # Show in prompt if in direnv directory
    initExtra = lib.mkAfter ''
      prompt_char() {
        if [ $DIRENV_FILE ]; then
            echo "> "
        else
            echo "$ "
        fi
      }
    '';
  };

  # Avoid big log output whenever using direnv
  home.sessionVariables.DIRENV_LOG_FORMAT = "";

  persist.directories = [
    "${lib.removePrefix "${config.home.homeDirectory}/" config.xdg.dataHome}/direnv"
  ];
}
