{ pkgs, ... }: {

  hardware.enableRedistributableFirmware = true;

  # Remove welcome line from getty
  environment.etc.issue.text = "";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.verbose = false;
    kernelParams = [ "quiet" ];
    consoleLogLevel = 2;

    kernel.sysctl."kernel.perf_event_paranoid" = 1; # rr debugger

    binfmt.emulatedSystems = [ "aarch64-linux" ]; # cross compilation

    loader = {
      systemd-boot.enable = true;
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
  };
}
