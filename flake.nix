{
  description = "Lubsch's NixOS and Home-Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = { 
      url = "github:nix-community/home-manager"; 
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
    nixos-generators = { 
      url = "github:nix-community/nixos-generators"; 
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
    flake-compat = {
      url = "github:inclyc/flake-compat"; # for nixd
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }@inputs: with nixpkgs; with builtins; {
    templates = mapAttrs 
      (name: _: { description = name; path = ./templates + "/${name}"; }) 
      (readDir ./templates);

    packages = lib.genAttrs lib.systems.flakeExposed
      (system: let pkgs = legacyPackages.${system}; in {
        nvim = import ./home/nvim/package.nix { inherit pkgs; with-servers = false; };
        install-iso = import ./nixos/install-iso.nix pkgs inputs.nixos-generators;
      });

    nixosConfigurations = mapAttrs (hostname: c: lib.nixosSystem {
      inherit (c) modules;
      specialArgs = { inherit inputs hostname; } // c.specialArgs;
    }) {
      "duke" = {
        modules = [
          ./nixos/common
          ./nixos/wireless.nix
          ./nixos/desktop.nix
          ./nixos/zsh.nix
          ./nixos/bluetooth.nix
        ];
        specialArgs = {
          # doas btrfs inspect-internal map-swapfile -r /swap/swapfile
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

    };
  };
}
