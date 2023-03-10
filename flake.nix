{
  description = "Lubsch's NixOS and Home-Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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

  outputs = { self, nixpkgs, impermanence, home-manager, firefox-addons, nix-colors }: 
  let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
  in {

    templates = import ./templates;

    packages = forAllSystems (system: {
      nvim = import ./pkgs/nvim {
      pkgs = nixpkgs.legacyPackages.${system};
      colorscheme = nix-colors.color-schemes.gruvbox;
      };
    });

    nixosConfigurations = {
      "duke" = nixpkgs.lib.nixosSystem { 
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          impermanence.nixosModules.impermanence
          ./nixos/common
          ./nixos/wireless.nix
          ./nixos/virtualisation.nix
          ./nixos/pipewire.nix
        ];
        specialArgs = {
          inherit nixpkgs; # For the registry
          hostname = "duke";
          system = "x86_64-linux";
          kernelModules = [ "kvm-intel" ];
          initrdModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
          cpuFreqGovernor = "powersave";

          users.lubsch = {
            authorizedKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+woFGMkb7kaOxHCY8hr6/d0Q/HIHIS3so7BANQqUe6" # arch
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvuIIrh2iuj2hX0zIzqLUC/5SD/ZJ3GaLcI1AyHDQuM" # droid
            ];
            hm-config = {
              imports = [
                nix-colors.homeManagerModule
                impermanence.nixosModules.home-manager.impermanence
                ./home/common
                ./home/nvim.nix
                ./home/desktop/common
                ./home/desktop/sway
              ];
              _module.args = {
                username = "lubsch";
                hostname = "duke";
                fonts = {
                  regular = {
                    name = "Fira Sans";
                    package = pkgs.fira;
                  };
                  mono = {
                    name = "Fira Code";
                    package = (pkgs.nerdfonts.override {fonts = [ "FiraCode"]; });
                  };
                };
                colorscheme = nix-colors.colorSchemes.gruvbox-dark-medium;
                firefox-addons = firefox-addons.packages.x86_64-linux;
              };
            };
          };
        };
      };
    };
  };
}
