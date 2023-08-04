{ pkgs, ... }: {

  xdg.mimeApps.enable = true;

  home.packages = [
    pkgs.xdg-utils
  ];

  programs.zsh.initExtra = ''o () { xdg-open "$@" &!}'';
}
