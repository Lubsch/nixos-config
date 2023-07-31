{ pkgs, ... }: {

  xdg.mimeApps.enable = true;

  home.packages = [
    pkgs.xdg-utils
  ];

  programs.zsh.shellAliases = {
    o = "xdg-open";
  };
}
