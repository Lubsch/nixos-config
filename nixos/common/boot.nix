{ kernelModules, initrdModules, ... }: {
  boot = {
    inherit kernelModules;
    initrd = { inherit kernelModules; };

    loader = {
      systemd-boot.enable = true;
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
  };
}
