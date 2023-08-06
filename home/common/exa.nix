{
  programs = {
    exa.enable = true;
    zsh.shellAliases = {
      l = "exa";
      ls = "exa -la --group-directories-first --no-user --no-permissions --icons";
      la = "exa -la --group-directories-first --icons";
      lt = "exa --group-directories-first --no-user --no-permissions --icons --tree";
    };
  };
}
