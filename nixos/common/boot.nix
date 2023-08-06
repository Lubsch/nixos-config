{ pkgs, kernelModules, initrdModules, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    inherit kernelModules;
    initrd = { 
      availableKernelModules = initrdModules; 
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
