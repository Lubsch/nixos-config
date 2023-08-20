{ lib, config, pkgs, ... }: {

  options = {
    kernelModules = lib.mkOption {};
    initrdModules = lib.mkOption {};
  };

  config.boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    inherit (config) kernelModules;
    initrd = { 
      availableKernelModules = config.initrdModules; 
      verbose = false;
    };

    consoleLogLevel = 2;
    kernelParams = [
      "quiet"
    ];

    loader = {
      systemd-boot.enable = true;
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
  };
}
