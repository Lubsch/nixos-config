{ config, pkgs, ... }:
{
  # home.sessionVariables.XCURSOR_PATH = "${config.xdg.dataHome}/icons";
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    # font = {
    #   inherit (config.my-fonts.regular) package name;
    #   size = 11;
    # };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  dconf.settings = {
    "ca/desrt/dconf-editor".show-warning = false;
    "org/gnome/desktop/wm/preferences".button-layout = "";
    "org/gnome/desktop/interface" = {
      cursor-blink = false;
      font-antialiasing = "rgba"; # sharper (?)
      # Some gtk4 applications (e.g. Evince) need "color-scheme"
      # set here explicitly. "gtk4.extraConfig" doesn't work.
      color-scheme = "prefer-dark";
    };
  };

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}
