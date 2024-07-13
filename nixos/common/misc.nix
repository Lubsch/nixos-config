{ lib, ... }:
{
  options.persist = lib.mkOption { };
  config = {
    system.stateVersion = "23.05";
    time.timeZone = "Europe/Berlin";

    persist.directories = [
      "/var/lib/systemd/coredump"
      "/var/log"
    ];
  };
}
