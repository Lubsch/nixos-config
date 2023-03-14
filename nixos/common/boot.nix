{ kernelModules, initrdModules, kernelParams, ... }: {
  boot = {
    inherit kernelModules kernelParams;
    initrd.kernelModules = initrdModules;

    loader = {
      systemd-boot.enable = true;
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
  };
}
