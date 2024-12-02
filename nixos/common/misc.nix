{ lib, ... }:
{
  options.persist = lib.mkOption { };
  config = {
    system.stateVersion = "23.05";
    time.timeZone = "Europe/Berlin";

    # unnecessary large dependency
    services.speechd.enable = false;

    # maybe speeds up firewall
    networking.nftables.enable = true;

    persist.directories = [
      "/var/lib/systemd/coredump"
      "/var/log"
      "/var/lib/nixos" # preserve uids/guids
    ];
  };
}
