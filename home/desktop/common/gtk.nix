{ pkgs, ... }: rec {
  gtk = {
    enable = true;
    /* font = { */
    /*   name = config.fontProfiles.regular.family; */
    /*   size = 14; */
    /* }; */
    theme = {
      name = "Plata-Noir-Compact";
      package = pkgs.plata-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
