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

  outputs = { self, nixpkgs, impermanence, home-manager, firefox-addons }: 
  let mkPkgs = system: nixpkgs.legacyPackages.${system}; 
  in {
    templates = import ./templates;
    packages = nixpkgs.lib.genAttrs 
      [ "x86_64-linux" "aarch64-linux" ]
      (system: import ./pkgs (mkPkgs system));

    nixosConfigurations = {
      "duke" = 
        let system = "x86_64-linux"; in 
      nixpkgs.lib.nixosSystem {
        pkgs = mkPkgs system;
        modules = [
          home-manager.nixosModules.home-manager
          impermanence.nixosModules.impermanence
          ./nixos/common
          ./nixos/encrypted-root.nix
          ./nixos/btrfs-optin-persistence.nix
          ./nixos/locale.nix
          ./nixos/wireless.nix
          ./nixos/pipewire.nix
        ];
        specialArgs = {
          hostname = "duke";
          inherit nixpkgs system;
          cpuFreqGovernor = "powersave";
          kernelModules = [ "kvm-intel" ];
          initrdModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];

          users.lubsch = {
            authorizedKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+woFGMkb7kaOxHCY8hr6/d0Q/HIHIS3so7BANQqUe6" # arch
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvuIIrh2iuj2hX0zIzqLUC/5SD/ZJ3GaLcI1AyHDQuM" # droid
            ];
            hm-config = {
              imports = [
                impermanence.nixosModules.home-manager.impermanence
                ./home/common
                ./home/nvim.nix
                ./home/desktop-common
                ./home/sway.nix
              ];
              _module.args = {
                username = "lubsch";
                inherit firefox-addons;
                fonts = with (mkPkgs system); {
                  regular = { name = "Fira Sans"; package = fira; };
                  mono = {
                    name = "FiraCode Nerd Font";
                    package = nerdfonts.override {fonts = [ "FiraCode"]; };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
