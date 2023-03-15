{ config, pkgs, ... }: {
  home.packages = with pkgs; [ trashy ];
  programs.zsh.shellAliases = {
    t = "trash put";
    rm = "rm -i";
  };

  home.persistence."/persist${config.home.homeDirectory}".directories = [ ".local/share/Trash" ];
}
