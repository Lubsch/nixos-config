{ nixpkgs }: {
  home.packages = [ nixpkgs.exa ];
  programs.zsh.shellAliases = {
    ls = "exa --color=always --group-directories-first -snew";
    la = "exa -a --color=always --group-directories-first -snew";
    ll = "exa -al --color=always --group-directories-first -snew --no-user --no-permissions --icons";
  };
}
