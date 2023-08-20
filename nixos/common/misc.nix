{ lib, config, pkgs, ... }: {

  options.droid = lib.mkOption { default = false; };
  options.persist = lib.mkOption {};
  

  config = {
    system.stateVersion = "23.05";
    time.timeZone = "Europe/Berlin";
    hardware.enableRedistributableFirmware = lib.mkIf (!config.droid) true;
    environment.enableAllTerminfo = lib.mkIf (!config.droid) true;
    environment.binsh = lib.mkIf (!config.droid) "${pkgs.dash}/bin/dash";

    persist.directories = [
      "/var/lib/systemd/coredump"
      "/var/log"
    ];
  };
}
