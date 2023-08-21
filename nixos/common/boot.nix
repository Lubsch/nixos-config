{ pkgs, ... }: {

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.verbose = false;
    consoleLogLevel = 2;
    kernelParams = [ "quiet" ];

    loader = {
      systemd-boot.enable = true;
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
  };
}
