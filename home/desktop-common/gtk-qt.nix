{ config, pkgs, ... }: {
  gtk = {
    enable = true;
    font = {
      inherit (config.fonts.regular) package name;
      size = 14;
    };
    theme = {
      name = "Plata-Noir-Compact";
      package = pkgs.plata-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };
}
