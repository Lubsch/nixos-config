{
  programs = {
    eza.enable = true;
    zsh.shellAliases = {
      l = "eza";
      la = "eza -la --group-directories-first --icons";
      ls = "eza -la --group-directories-first --icons --no-user --no-permissions";
      lt = "eza     --group-directories-first --icons --no-user --no-permissions --tree";
      lta = "eza -a --group-directories-first --icons --no-user --no-permissions --tree";
    };
  };
}
