{ lib, config, ... }:
{
  services.syncthing = {
    enable = true;
    extraOptions = [ "--no-default-folder" ];
  };

  persist.directories = [
    "${lib.removePrefix "${config.home.homeDirectory}/" config.xdg.stateHome}/syncthing"
  ];
}
