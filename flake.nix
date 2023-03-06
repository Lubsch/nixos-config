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
    agenix = {
      url = "github:ryantm/agenix";
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

  outputs = { self, nixpkgs, hardware, agenix, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      hosts = import ./hosts.nix { inherit hardware; };
      lib = import ./lib.nix { inherit inputs; };
      authorizedKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDS42veAAS9JxykhqWAhJq/llMEqNWScUHeH7bbv6w7BhzEkhpokEtpq+Mkp1EM7zJgq5FIEQcuQtoEZkZpYqR+c8bAKXHkz8KDBvg4yI1Y5AjRd4vWistAMNicoatwLU5gaPsmhbFNE2HGPVEO+8pBMruSJy+fHAgESSWgn/GYGazv/qCohKPp/7Mw4pXdrdynMIsB7KbHtuXx/zn2+R1az0zfP7XWv9qiyniINrPGBwWMtyYqdNd0K4G1FBWNjfVwGCUw2W50/vX5B2y0FI/gLpzg6VSFksOiH9S8pAR/4vN71fnHZw7vOuFIFq8PSedgFjsTuarELNBWRuKMWIxmej/UChmtNEqMOLOSkHNv3LBLHFFFljoOnaIoCTgSAn2I5+yHsaEy/TWhi6D0nCYA1UQBB4mVeoElFoAM1FAOV7jaMSMKHMJhSrDXtFmpJGXf2eEGyuX467q+rhb/MgW7QtIkMaOvMYbH5kiz+gleZmQ5K73yu5xmrBz66G6Flgs= (lubsch@arch)"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvuIIrh2iuj2hX0zIzqLUC/5SD/ZJ3GaLcI1AyHDQuM"
      ];
    in {
      templates = import ./templates;
      overlays = import ./overlays;

      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              nix
              home-manager
              git
              rage
              agenix.defaultPackage.${system}
              magic-wormhole
            ];
          };
        }
      );

      nixosConfigurations = {
        "duke" = nixpkgs.lib.nixosSystem {
          modules = [
            ./nixos/common
            ./nixos/wireless.nix
            ./nixos/virtualisation.nix
            ./nixos/pipewire.nix
            impermanence.nixosModules.impermanence
            agenix.nixosModule
            {
              config._module.args = {
                hostname = "duke";
                system = "x86_64-linux";
                kernelModules = [ "kvm-intel" ];
                initrdModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
                users.lubsch.arguments = { inherit authorizedKeys; };
              };
            }
          ];
        };
      };

      homeConfigurations = {
        "lubsch@duke" = home-manager.lib.homeManagerConfiguration {
          modules = [
            ./home/common
            ./home/nvim
            impermanence.nixosModules.home-manager.impermanence
            {
              config._module.args = {
                username = "lubsch";
                hostname = "duke";
                inherit (nix-colors) colorSchemes;
                firefox-addons = firefox-addons.packages.x86_64-linux;
              };
            }
          ];
        };
      };
    };
}
