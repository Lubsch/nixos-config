{
  description = "Lubsch's NixOS and Home-Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, hardware, impermanence, home-manager, firefox-addons, nix-colors, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      templates = import ./templates;
      overlays = import ./overlays;

      nixosConfigurations = {
        "duke" = nixpkgs.lib.nixosSystem {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            { config._module.args = {
                hostname = "duke";
                system = "x86_64-linux";
                kernelModules = [ "kvm-intel" ];
                initrdModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
                users.lubsch.arguments.authorizedKeys = import ./authorizedKeys.nix;
            }; }
            impermanence.nixosModules.impermanence
            ./nixos/common
            ./nixos/wireless.nix
            ./nixos/virtualisation.nix
            ./nixos/pipewire.nix
          ];
        };
      };

      homeConfigurations = {
        "lubsch@duke" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            { config._module.args = {
                username = "lubsch";
                hostname = "duke";
                inherit (nix-colors) colorSchemes;
                firefox-addons = firefox-addons.packages.x86_64-linux;
            }; }
            impermanence.nixosModules.home-manager.impermanence
            ./home/common
            ./home/nvim
          ];
        };
      };
    };
}
