{ pkgs, ... }: {
  home.packages = [ pkgs.evince ];
  xdg.mimeApps.defaultApplications."application/pdf" = [ "evince.desktop" ];
}
