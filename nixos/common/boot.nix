{ kernelModules, initrdModules, kernelParams, ... }: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      timeout = 0;

      # The installation of the bootloader can touch efi vars
      efi.canTouchEfiVariables = true;
    };

    inherit kernelModules kernelParams;
    initrd.kernelModules = initrdModules;
  };
}
