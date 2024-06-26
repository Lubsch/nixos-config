{ pkgs, ... }: {
  # re script which used to be a shell alias
  # - Regenerates and garbage collects files in generated
  # - Rebuilds nixos system
  # - Commits if successful (with empty message)

  home.packages = [
    (pkgs.writeScriptBin "re" /*python*/ ''
      #!${pkgs.python3}/bin/python
      ${builtins.readFile ./re-script.py}
    '')
  ];
}
