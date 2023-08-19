{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = { 
      url = "github:nix-community/home-manager"; 
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    proton-ge = {
      url = "https://raw.githubusercontent.com/Shawn8901/nix-configuration/main/packages/proton-ge-custom/default.nix";
      flake = false;
    };
    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { nixpkgs, nix-on-droid, ... }@inputs: with nixpkgs; with builtins; {

    templates = import ./templates;

    packages = mapAttrs (system: pkgs: { 
      disko = inputs.disko.packages.${system}.disko;
      nvim-lsp = pkgs.callPackage ./home/nvim/package.nix {};
      nvim = pkgs.callPackage ./home/nvim/package.nix { lsp = false; };
    }) legacyPackages;

    nixosConfigurations = mapAttrs (hostname: config: lib.nixosSystem {
      inherit (config) modules;
      system = config.system or "x86_64-linux";
      specialArgs = config // { inherit inputs hostname; };
    }) {

      "shah" = {
        main-disk = "/dev/sda";
        cpuVendor = "intel";
        initrdModules = [ "ehci_pci" "ahci" "sd_mod" "sdhci_pci" ];
        kernelModules = [ "kvm-intel" ];
        swap = { size = 8; offset = "1844480"; };
        modules = [
          ./nixos/common
          ./nixos/impermanence.nix
          ./nixos/wireless.nix
          ./nixos/desktop.nix
          ./nixos/zsh.nix
          ./nixos/bluetooth.nix
          ./nixos/virtualisation.nix
          ./nixos/printing.nix
        ];
        users."lubsch" = [
          ./home/common
          ./home/desktop-common
          ./home/impermanence.nix
          ./home/nvim
          ./home/hyprland.nix
          ./home/mail.nix
          ./home/syncthing.nix
          ./home/keepassxc.nix
          ./home/qutebrowser.nix
        ];
      };

       "duke" = {
         impermanence = false;
         main-disk = "/dev/sda";
         cpuVendor = "intel";
         initrdModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
         kernelModules = [ "kvm-intel" ];
         swap = { size = 8; offset = "1256037"; };
         modules = [
           ./nixos/common
           ./nixos/wireless.nix
           ./nixos/desktop.nix
           ./nixos/zsh.nix
           ./nixos/bluetooth.nix
         ];
         users."lubsch" = [
           ./home/common
           ./home/nvim
           ./home/desktop-common
           ./home/hyprland.nix
           ./home/mail.nix
           ./home/syncthing.nix
           ./home/keepassxc.nix
           ./home/qutebrowser.nix
         ];
       };

    };

    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
      modules = [ 
        ./nixos/common/nix.nix
        ./nixos/common/misc.nix
        ./nixos/droid.nix
      ];
      extraSpecialArgs = { 
        inherit inputs;
        username = "lubsch";
        userModules = [
          ./home/common
          ./home/nvim
        ];
      };
    };

  };
}
