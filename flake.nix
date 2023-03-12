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
  let
    forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];

    makePkgs = system: import nixpkgs { 
      inherit system;
      config = { 
        allowUnfree = true; 
        enableParallelBuilding = true;
      };
    };  
  in {
    packages = forEachSystem (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; });
    templates = import ./templates;

    nixosConfigurations = {
      "duke" = 
        let pkgs = makePkgs "x86_64-linux"; in 
      nixpkgs.lib.nixosSystem {
        inherit pkgs;
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
          inherit nixpkgs; # For the registry
          hostname = "duke";
          system = "x86_64-linux";
          initrdModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
          kernelModules = [ "kvm-intel" ];
          cpuFreqGovernor = "powersave";

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
                ./home/sway
              ];
              _module.args = {
                username = "lubsch";
                fonts = {
                  regular = {
                    name = "Fira Sans";
                    package = pkgs.fira;
                  };
                  mono = {
                    name = "FiraCode Nerd Font";
                    package = pkgs.nerdfonts.override {fonts = [ "FiraCode"]; };
                  };
                };
                firefox-addons = firefox-addons.x86_64-linux;
              };
            };
          };
        };
      };
    };
  };
}
