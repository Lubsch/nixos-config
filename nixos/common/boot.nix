# has also accumulated config for speeding up startup
{ lib, pkgs, ... }: {

  hardware.enableRedistributableFirmware = true;

  # Remove welcome line from getty
  environment.etc.issue.text = "";

  # Remove (unnecessary, I hope) delay from waiting on network
  systemd.targets.network-online.wantedBy = lib.mkForce [];
  # Don't flush journals from volataile storage which are persistent anyway
  # see https://www.freedesktop.org/software/systemd/man/latest/journald.conf.html
  systemd.services.systemd-journal-flush.enable = false;
  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      systemd.enable = true; # experimental, for concurrent stage 1
      verbose = false;
    };
    kernelParams = [ "quiet" ];
    consoleLogLevel = 2;

    kernel.sysctl."kernel.perf_event_paranoid" = 1; # for rr debugger

    binfmt.emulatedSystems = [ "aarch64-linux" ]; # cross compilation

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        consoleMode = "auto";
      };
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
  };
}
