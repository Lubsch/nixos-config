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
}
