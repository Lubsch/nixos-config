{ pkgs, ... }: {
  home.packages = [ (import ../pkgs/dwl pkgs) ];

  programs.zsh.loginExtra = ''
    [ "$(tty)" = "/dev/tty1" ] && dwl
  '';
}
