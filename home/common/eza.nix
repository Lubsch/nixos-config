{
  programs = {
    eza.enable = true;
    zsh.shellAliases = {
      l = "eza";
      la = "eza -la --group-directories-first --icons=auto";
      ls = "eza -la --group-directories-first --icons=auto --no-user --no-permissions";
      lt = "eza -a  --group-directories-first --icons=auto --no-user --no-permissions --tree";
    };
  };
}
