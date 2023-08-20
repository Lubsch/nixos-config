{ pkgs, ... }: {
  home.packages = [ (pkgs.writeShellScriptBin "setup-mail" ''
    # deps keepass
    echo TODO
  '') ];
}
