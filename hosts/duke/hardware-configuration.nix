{
  imports = [
    ../common/optional/btrfs-optin-persistence.nix
    ../common/optional/encrypted-root.nix
  ];

  boot = {
    kernelModules = [ "kvm-intel" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
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
  hardware.cpu.intel.updateMicrocode = true;
}
