{ pkgs, ... }: {

  hardware.enableRedistributableFirmware = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.verbose = false;
    consoleLogLevel = 2;
    kernelParams = [ "quiet" ];

    kernel.sysctl."kernel.perf_event_paranoid" = 1; # rr debugger

    loader = {
      systemd-boot.enable = true;
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
  };
}
