{ config, ... }: {
  services.syncthing = {
    enable = true;
    extraOptions = [
      "--no-default-folder"
    ];
  };

  home.persistence."/persist${config.home.homeDirectory}".directories = [ 
    ".config/syncthing"
  ];
}
