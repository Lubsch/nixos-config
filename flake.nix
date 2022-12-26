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
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      hosts = import ./hosts.nix;
      lib = import ./lib.nix { inherit nixpkgs home-manager; };

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    in
    rec {
      templates = import ./templates;
      overlays = import ./overlays;

      packages = forAllSystems (system:
        import ./pkgs {
          pkgs = nixpkgs.legacyPackages.${system};
          inherit inputs system;
        }
      );

      nixosConfigurations = lib.makeNixosConfigurations hosts;
      homeConfigurations = lib.makeHomeConfigurations hosts;

    };
}
