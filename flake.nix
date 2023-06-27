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
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-generators, ... }@inputs: with nixpkgs; {
    templates = mapAttrs 
      (t: _: { description = t; path = ./templates + "/${t}"; }) 
      (readDir ./templates);

    packages = lib.genAttrs lib.systems.flakeExposed
      (system: let pkgs = legacyPackages.${system}; in {
        nvim = import ./home/nvim/package.nix pkgs;
        install-iso = import ./nixos/install-iso.nix pkgs nixos-generators;
      });

    nixosConfigurations = {
      "duke" = lib.nixosSystem {
        modules = [
          ./nixos/common
          ./nixos/wireless.nix
          ./nixos/desktop.nix
          ./nixos/zsh.nix
          ./nixos/bluetooth.nix
        ];
        specialArgs = {
          inherit inputs;
          hostname = "duke";
          system = "x86_64-linux";
          impermanence = true;
          # doas btrfs inspect-internal map-swapfile -r /swap/swapfile
          swap = { size = 8192; offset = "1256037"; };
          cpu = { vendor = "intel"; freq = "powersave"; };
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
    "shah" = lib.nixosSystem {
        modules = [
          ./nixos/common
          ./nixos/wireless.nix
          ./nixos/desktop.nix
          ./nixos/zsh.nix
          ./nixos/bluetooth.nix
        ];
        specialArgs = {
          inherit inputs;
          hostname = "shah";
          system = "x86_64-linux";
          impermanence = true;
          # doas btrfs inspect-internal map-swapfile -r /swap/swapfile
          swap = { size = 8192; offset = "1256037"; };
          cpu = { vendor = "intel"; freq = "powersave"; };
          kernelModules = [ ];
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
