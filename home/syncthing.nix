{
  services.syncthing = {
    enable = true;
    extraOptions = [
      "--no-default-folder"
    ];
  };

  setup-scripts.syncthing = {
    deps = [ ];
    script = ''
      echo You might want to sync:
      echo Uni
      echo Old Documents
      echo Notes
      echo Pictures
      echo Videos
      echo Projects
      $BROWSER localhost:8384
    '';
  };

  persist.directories = [ 
    ".config/syncthing"
  ];
}
