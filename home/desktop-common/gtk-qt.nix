{ config, pkgs, ... }: {
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    font = {
      inherit (config.my-fonts.regular) package name;
      size = 12;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-blink = false; # doesn't seem to work in qutebrowser
      gtk-menu-popup-delay = 0;
      gtk-can-change-accels = 1; # make keyboard shortcuts editable
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
    };
    gtk4.extraConfig = config.gtk.gtk3.extraConfig;
    gtk2.extraConfig = config.xdg.configFile."gtk-3.0/settings.ini".text;
  };
  
  qt = {
    enable = true;
    platformTheme = "gtk";
  };
}
