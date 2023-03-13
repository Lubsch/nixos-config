{ config, pkgs, ... }: {
  home.packages = with pkgs; [ trash-cli ];
  programs.zsh.shellAliases = {
    rm = "trash";
  };

  home.persistence."/persist${config.home.homeDirectory}".directories = [ 
    ".local/share/Trash" 
  ];
}
