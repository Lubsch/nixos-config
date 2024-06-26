{ config, pkgs, ... }: {
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    # font = {
    #   inherit (config.my-fonts.regular) package name;
    #   size = 12;
    # };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gtk4;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    # Some gtk4 applications (e.g. Evince) need "color-scheme"
    # set here explicitly. "gtk4.extraConfig" doesn't work.
    color-scheme = "prefer-dark";
    cursor-blink = false;
  };
  
  qt = {
    enable = true;
    style = {
      name = "adwaita";
      package = pkgs.adwaita-qt6;
    };
  };

}
