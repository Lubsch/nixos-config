{ lib, config, pkgs, ... }: {

  options.persist = lib.mkOption {};

  config = {
    system.stateVersion = "23.05";
    time.timeZone = "Europe/Berlin";
    hardware.enableRedistributableFirmware = true;
    environment.enableAllTerminfo = true;
    environment.binsh = "${pkgs.dash}/bin/dash";
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    persist.directories = [
      "/var/lib/systemd/coredump"
      "/var/log"
    ];
  };
}
