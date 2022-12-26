{ pkgs, ... }: {
  home.packages = [ pkgs.exa ];
  programs.zsh.shellAliases = {
    l = "exa --group-directories-first ";
    la = "exa -a --group-directories-first ";
    ls = "exa -al --group-directories-first --no-user --no-permissions --icons";
  };
}
