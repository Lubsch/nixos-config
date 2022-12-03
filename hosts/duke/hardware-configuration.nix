{
  imports = [
    ../common/optional/btrfs-optin-persistence.nix
    ../common/optional/encrypted-root.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhcpi_pci" "ahci" "sd_mod" "rtsx_usb_sdmmc" ];
      boot.kernelModules = [ "kvm-intel" ];
    };
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";
  powerManagement.cpuFreqGovernor = "powersave";
}
