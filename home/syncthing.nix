{
  services.syncthing = {
    enable = true;
    extraOptions = [
      "--no-default-folder"
    ];
  };

  persist.directories = [ 
    ".config/syncthing"
  ];
}
