{ pkgs }: {
  home.packages = [
    pkgs.xdg-utils
  ];

  zsh.shellAliases = {
    o = "xdg-open";
  };
}
