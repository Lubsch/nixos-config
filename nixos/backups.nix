{ config, pkgs, ... }:
let
  passwordFile = "/persist/etc/passwords/restic";
in
{
  services.restic.backups = {
    inherit passwordFile;
    initialize = true;
    paths = [ config.services.syncthing.dataDir ];
    timerConfig.OnCalendar = "daily";
  };

  system.activationScripts.restic-password.text = ''
    if [ ! -f ${passwordFile} ]; then
      mkdir -p "$(dirname ${passwordFile})"
      echo "Set the password for restic"
      ${pkgs.mkpasswd}/bin/mkpasswd -m sha-512 > ${passwordFile}
      chmod 600 "${passwordFile}"
    fi
  '';

  services.syncthing = {
    enable = true;
  };

  persist.directories = [ config.services.syncthing.dataDir ];
}
