{ pkgs, ... }: {

  xdg.mimeApps.enable = true;

  home.packages = [
    (pkgs.writeShellScriptBin "xdg-open" ''
      handlr open "$@"
    '')
    pkgs.handlr
  ];

  programs.zsh.initExtra = ''o () { handlr open "$@" &!}'';
}
