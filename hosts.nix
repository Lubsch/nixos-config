 {
  "duke" = {
    modules = [
      ./nixos/common
      ./nixos/wireless.nix
      ./nixos/desktop.nix
      ./nixos/zsh.nix
    ];
    specialArgs = {
      system = "x86_64-linux";
      impermanence = true;
      # doas btrfs inspect-internal map-swapfile -r /swap/swapfile
      swap = { size = 8192; offset = "1199735"; };
      cpu = { vendor = "intel"; freq = "powersave"; };
      kernelModules = [ "kvm-intel" ];
      initrdModules= [ 
        "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc"
      ];
      users."lubsch".modules = [
        ./home/common
        ./home/nvim.nix
        ./home/desktop-common
        ./home/hyprland.nix
        ./home/dwl.nix
      ];
    };
  };
}
