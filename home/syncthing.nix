{ lib, config, ... }:
{
  services.syncthing = {
    enable = true;
    extraOptions = [ "--no-default-folder" ];
  };

  persist.directories = [
    ".local/state/syncthing"
  ];
}
