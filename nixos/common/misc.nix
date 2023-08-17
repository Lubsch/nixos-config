{ lib, config, pkgs, ... }: {

  options.droid = lib.mkOption { default = false; };
  options.persist = lib.mkOption {};

  config = {
    system.stateVersion = "23.05";
    time.timeZone = "Europe/Berlin";
    # environment."bin${if config.droid then "S" else "s"}h" = lib.mkForce "${pkgs.dash}/bin/dash";

    persist.directories = [
      "/var/lib/systemd/coredump"
      "/var/log"
    ];

  };
}
