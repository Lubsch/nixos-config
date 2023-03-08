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
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, hardware, impermanence, home-manager, firefox-addons, nix-colors, ... }: 
  let

    makeConfig = configFunction: { system, arguments, modules }:
      configFunction {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          { config._module.args = arguments; }
        ] ++ modules;
      };

    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

  in rec {

    templates = import ./templates;

    packages = forAllSystems (system: {
      nvim = import ./pkgs/nvim {
        pkgs = nixpkgs.legacyPackages.${system};
        colorscheme = nix-colors.color-schemes.gruvbox;
      };
    });

    nixosConfigurations = {
      "duke" = makeConfig nixpkgs.lib.nixosSystem { 
        system = "x86_64-linux";
        arguments = {
          hostname = "duke";
          kernelModules = [ "kvm-intel" ];
          initrdModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
          cpuFreqGovernor = "powersave";
          users.lubsch.authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+woFGMkb7kaOxHCY8hr6/d0Q/HIHIS3so7BANQqUe6" # arch
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvuIIrh2iuj2hX0zIzqLUC/5SD/ZJ3GaLcI1AyHDQuM" # droid
          ];
        };
        modules = [
          impermanence.nixosModules.impermanence
          ./nixos/common
          ./nixos/wireless.nix
          ./nixos/virtualisation.nix
          ./nixos/pipewire.nix
        ];
      };
    };

    homeConfigurations = {
      "lubsch@duke" = makeConfig home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        arguments = {
          username = "lubsch";
          hostname = "duke";
          colorscheme = nix-colors.colorSchemes.gruvbox;
          firefox-addons = firefox-addons.packages.x86_64-linux;
        };
        modules = [
          nix-colors.homeManagerModule
          impermanence.nixosModules.home-manager.impermanence
          ./home/common
          ./home/nvim
        ];
      };
    };

  };
}
