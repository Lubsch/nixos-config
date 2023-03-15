{ pkgs, ... }: {
  home.packages = [ pkgs.river ];
  
  programs.zsh.loginExtra = ''
    [ "$(tty)" = "/dev/tty1" ] && river
  '';

  xdg.configFile."river/init" = {
    executable = true;
    source = ./init;
  };
}
