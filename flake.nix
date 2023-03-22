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
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { home-manager, nixpkgs, ... }@inputs: 
  let
    hosts = {
      "duke" = {
        modules = [
          ./nixos/common
          ./nixos/wireless.nix
          ./nixos/desktop.nix
          ./nixos/zsh.nix
        ];
        specialArgs = {
          system = "x86_64-linux";
          impermanence = true;
          # doas btrfs inspect-internal map-swapfile -r /swap/swapfile
          swap = { size = 8192; offset = "1199735"; };
          cpu = { vendor = "intel"; freq = "powersave"; };
          kernelModules = [ "kvm-intel" ];
          initrdModules= [ 
            "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc"
          ];
          users = [ "lubsch" ];
        };
      };
    };
    users = {
      "lubsch" = {
      	hostname = "duke";
        modules = [
          ./home/common
          ./home/nvim.nix
          ./home/desktop-common
          ./home/hyprland.nix
          ./home/dwl.nix
        ];
      };
    };
    in {
      templates = import ./templates;
      packages = import ./pkgs nixpkgs;

      homeConfigurations = nixpkgs.lib.mapAttrs'
        (username: user: with user; {
          name = "${username}@${hostname}";
            value = let host = hosts.${hostname}; in
            home-manager.lib.homeManagerConfiguration {
              inherit modules;
              pkgs = nixpkgs.legacyPackages.${host.specialArgs.system};
              extraSpecialArgs = { inherit username inputs host; };
          };
        })
        users;

      nixosConfigurations = builtins.mapAttrs
        (hostname: host: nixpkgs.lib.nixosSystem 
          (host // { specialArgs = { inherit hostname inputs; }; }))
        hosts;
    };
}
