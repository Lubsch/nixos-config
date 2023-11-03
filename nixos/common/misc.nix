{ lib, ... }: {
  options.persist = lib.mkOption {};
  config = {
    system.stateVersion = "23.05";
    time.timeZone = "Europe/Berlin";
    # Because a contour is marked as broken
    # environment.enableAllTerminfo = true;

    persist.directories = [
      "/var/lib/systemd/coredump"
      "/var/log"
    ];
  };
}
