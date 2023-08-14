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
  };

  outputs = { nixpkgs, ... }@inputs: with nixpkgs; with builtins; {

    templates = mapAttrs (n: _: { description = n; path = ./templates + "/${n}"; }) (readDir ./templates);

    packages = mapAttrs (system: pkgs: { 
      disko = inputs.disko.packages.${system}.disko;
    } // import ./home/nvim/package.nix pkgs) legacyPackages;


    nixosConfigurations = mapAttrs (hostname: config: lib.nixosSystem {
      inherit (config) modules;
      specialArgs = config // { inherit inputs hostname; };
    }) {

      "shah" = {
        system = "x86_64-linux";
        main-disk = "/dev/sda";
        impermanence = true;
        cpuVendor = "intel";
        initrdModules = [ "ehci_pci" "ahci" "sd_mod" "sdhci_pci" ];
        kernelModules = [ "kvm-intel" ];
        swap = { size = 8; offset = "1844480"; };
        modules = [
          ./nixos/common
          ./nixos/wireless.nix
          ./nixos/desktop.nix
          ./nixos/zsh.nix
          ./nixos/bluetooth.nix
          ./nixos/virtualisation.nix
          ./nixos/printing.nix
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
  };
}
