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

  outputs = { nixpkgs, ... }@inputs: {
    templates = import ./templates;
    packages = import ./pkgs nixpkgs;

    nixosConfigurations = {
      "duke" = nixpkgs.lib.nixosSystem {
        modules = [
          ./nixos/common
          ./nixos/wireless.nix
          ./nixos/desktop.nix
          ./nixos/zsh.nix
        ];
        specialArgs = {
          inherit inputs;
          hostname = "duke";
          system = "x86_64-linux";
          encrypted = true;
          impermanence = true;
          # doas btrfs inspect-internal map-swapfile -r /swap/swapfile
          swap = { size = 8192; offset = "1199735"; };
          cpu = { vendor = "intel"; freq = "powersave"; };
          kernelModules = [ "kvm-intel" ];
          initrdModules= [ 
            "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc"
          ];
          users."lubsch".imports = [
            ./home/common
            ./home/nvim.nix
            ./home/desktop-common
            ./home/sway.nix
          ];
        };
      };

    };
  };
}
