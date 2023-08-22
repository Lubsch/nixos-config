{ config, pkgs, ... }: {
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    font = {
      inherit (config.my-fonts.regular) package name;
      size = 12;
    };
    theme = {
      name = "Materia:dark";
      package = pkgs.materia-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-cursor-blink = false; # doesn't seem to work in qutebrowser
      gtk-menu-popup-delay = 0;
      gtk-can-change-accels = 1; # make keyboard shortcuts editable
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };
}
