{
  programs = {
    eza.enable = true;
    zsh.shellAliases = {
      l = "eza";
      ls = "eza -la --group-directories-first --no-user --no-permissions --icons";
      la = "eza -la --group-directories-first --icons";
      lt = "eza --group-directories-first --no-user --no-permissions --icons --tree";
      lta = "eza -a --group-directories-first --no-user --no-permissions --icons --tree";
    };
  };
}
