{ pkgs, ... }: {
  home.packages = [
    pkgs.handlr
    (pkgs.writeShellScriptBin "xdg-open" ''
      handlr open
    '')
  ];

  programs.zsh.shellAliases = {
    o = "handlr open";
  };
}
