{ kernelModules, initrdModules, ... }: {
  boot = {
    inherit kernelModules;
    initrd = { 
      kernelModules = initrdModules; 
      verbose = false;
    };

    kernelParams = [
      "quiet"
      "loglevel=3"
    ];

    loader = {
      systemd-boot.enable = true;
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
  };
}
