{ config, pkgs, ... }: {
  home.packages = [ (import ../pkgs/dwl { inherit pkgs config; }) ];

  programs.zsh.loginExtra = ''
    [ "$(tty)" = "/dev/tty1" ] && dwl
  '';
}
