{ config, pkgs, ... }:
let
  passwordFile = "/var/lib/passwords/restic-password";
in {
  services.restic.backups = {
    initialize = true;
    paths = [ config.services.syncthing.dataDir ];
    inherit passwordFile;
    timerConfig.OnCalendar = "daily";
  };

  system.activationScripts.restic-password = {
    text = ''
      if [ ! -e ${passwordFile} ]; then
        printf "Enter the restic "
        ${pkgs.mkpasswd}/bin/mkpasswd -m sha-512 > ${passwordFile}
      fi
    '';
    deps = [ "createPersistentStorageDirs" ];
  };

  services.syncthing = {
    enable = true;
  };


  persist.directories = [
    { directory = "/var/lib/passwords"; mode = "0600"; }
    config.services.syncthing.dataDir
  ];

}
