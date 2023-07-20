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
    dependencies = [ ];
    script = ''
      echo What you might want to sync:
      echo Passwords
      echo Uni
      echo Notes
      echo Pictures
      $BROWSER localhost:8384
    '';
  };
}
