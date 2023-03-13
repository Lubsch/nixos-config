{
  description = "Lubsch's NixOS and Home-Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    templates = import ./templates;
    packages = import ./pkgs nixpkgs;

    nixosConfigurations = {
      "duke" = nixpkgs.lib.nixosSystem {
        modules = [
          ./nixos/common
          ./nixos/encrypted-root.nix
          ./nixos/impermanence.nix
          ./nixos/locale.nix
          ./nixos/wireless.nix
          ./nixos/pipewire.nix
        ];
        specialArgs = {
          inherit inputs;
          hostname = "duke";
          system = "x86_64-linux";
          cpuFreqGovernor = "powersave";
          kernelModules = [ "kvm-intel" ];
          initrdModules= [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
          users."lubsch".hm-config = {
            imports = [
              ./home/common
              ./home/nvim.nix
              ./home/desktop-common
              ./home/sway.nix
              ./home/impermanence.nix
            ];
            _module.args = {
              username = "lubsch";
              inherit inputs;
            };
          };
        };
      };

    };
  };
}
