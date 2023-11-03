{ config, pkgs, ... }:
let
  passwordFile = ""/persist"
    then "/persist"
    else ""}
  /etc/password/restic";
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
        printf "Set the restic "
        ${pkgs.mkpasswd}/bin/mkpasswd -m sha-512 > ${passwordFile}
      fi
    '';
    deps = [ "createPersistentStorageDirs" ];
  };

  services.syncthing = {
    enable = true;
  };


  persist.directories = [
    config.services.syncthing.dataDir
  ];

}
