{ pkgs, ... }: {
  home.packages = [ pkgs.evince ];
  xdg.mimeApps.defaultApplications.".pdf" = [ "evince.desktop" ];
}
