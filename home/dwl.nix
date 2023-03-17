{
  home.packages = [ (import ../pkgs/dwl) ];

  programs.zsh.loginExtra = ''
    [ "$(tty)" = "/dev/tty1" ] && dwl
  '';
}
