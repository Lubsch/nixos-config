{
  description = "Lubsch's NixOS and Home-Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = { 
      url = "github:nix-community/home-manager"; 
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
  };

  outputs = { nixpkgs, ... }@inputs: with nixpkgs; with builtins; {
    templates = mapAttrs (n: _: { path = ./templates + "/${n}"; }) (readDir ./templates);

    packages = mapAttrs (_: pkgs: {
      nvim = import ./home/nvim/package.nix { inherit pkgs; with-servers = false; };
      nvim-lsp = import ./home/nvim/package.nix { inherit pkgs; with-servers = true; };
    }) legacyPackages;

    nixosConfigurations = mapAttrs (hostname: config: lib.nixosSystem {
      inherit (config) modules;
      specialArgs = { 
        inherit inputs hostname; 
        system = "x86_64-linux";
        impermanence = true;
        # Change to disable full-drive encryption
        main-drive = "/dev/mapper/${hostname}";
        kernelModules = [ ];
        initrdModules = [ ];
        users = { };
      } // config.specialArgs;
    }) {

    "shah" = {
        modules = [
          ./nixos/common
          ./nixos/wireless.nix
          ./nixos/desktop.nix
          ./nixos/zsh.nix
          ./nixos/bluetooth.nix
        ];
        specialArgs = {
          swap = { size = 8; offset = "2106624"; };
          cpuVendor = "intel";
          initrdModules = [ 
            "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci"
          ];
          users."lubsch".imports = [
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

      "duke" = {
        modules = [
          ./nixos/common
          ./nixos/wireless.nix
          ./nixos/desktop.nix
          ./nixos/zsh.nix
          ./nixos/bluetooth.nix
        ];
        specialArgs = {
          swap = { size = 8; offset = "1256037"; };
          cpuVendor = "intel";
          kernelModules = [ "kvm-intel" ];
          initrdModules = [ 
            "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc"
          ];
          users."lubsch".imports = [
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
  };
}
