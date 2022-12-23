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
    sops-nix = {
      url = "github:mic92/sops-nix";
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

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    rec {
      mkHome = { username, hostname, architecture }: home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${architecture};
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ (./home + "/${username}/${hostname}.nix") ];
        };

      templates = import ./templates;
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      overlays = import ./overlays;

      /* packages = forAllSystems (system: */
      /*   import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; } */
      /* ); */

      nixosConfigurations = {
        # Laptop
        duke = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/duke ];
        };
      };

      homeConfigurations = {
        # Laptop
        "lubsch@duke" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/lubsch/duke.nix ];
        };
      };
    };
}
