{ lib, config, ... }:
{
  services.syncthing = {
    enable = true;
    extraOptions = [ "--no-default-folder" ];
  };

  persist.directories = [
    {
      directory = "${lib.removePrefix "${config.home.homeDirectory}/" config.xdg.stateHome}/syncthing";
      method = "symlink";
    }
  ];
}
