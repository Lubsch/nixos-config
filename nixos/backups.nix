{ config, pkgs, ... }:
let
  passwordFile = "/etc/passwords/restic";
in {
  services.restic.backups = {
    inherit passwordFile;
    initialize = true;
    paths = [ config.services.syncthing.dataDir ];
    timerConfig.OnCalendar = "daily";
  };

  system.activationScripts.restic-password = {
    text = ''
      if [ ! -f ${passwordFile} ]; then
        mkdir -p "$(dirname ${passwordFile})"
        echo "Set the password for restic"
        ${pkgs.mkpasswd}/bin/mkpasswd -m sha-512 > ${passwordFile}
        chmod 600 "${passwordFile}"
      fi
    '';
    deps = [ "createPersistentStorageDirs" ];
  };

  services.syncthing = {
    enable = true;
  };


  persist.directories = [
    "/etc/passwords"
    config.services.syncthing.dataDir
  ];

}
