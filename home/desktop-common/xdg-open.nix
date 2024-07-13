{ pkgs, ... }:
{
  xdg.mimeApps.enable = true;

  home.packages = [
    pkgs.handlr
    (pkgs.writeShellScriptBin "xdg-open" ''
      handlr open "$@"
    '')
  ];

  programs.zsh.shellAliases = {
    o = "xdg-open";
  };
}
