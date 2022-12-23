{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  j = pkgs.writeShellScriptBin "j" ''
    if [[ "$argv[1]" == "-"* ]]; then
        zx "$@"
    else
        cd "$@" 2> /dev/null || zx "$@"
    fi
  '';
}
