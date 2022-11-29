{
  description = "The one configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/NUR";
    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      lib = import ./lib { inherit inputs; };
      inherit (lib) mkSystem mkHome importAttrset forAllSystems;
    in
    {

      templates = import ./templates;

      devShells = forAllSystems (system: {
        default = inputs.nixpkgs.legacyPackages.${system}.callPackage ./shell.nix { };
      });

      nixosConfigurations = {
        duke = mkSystem {
          hostname = "duke";
          system = "x86_64-linux";
          persistence = true;
        };
      };

      homeConfigurations = {
        "lubsch@duke" = mkHome {
          username = "lubsch";
          hostname = "duke";
          persistence = true;
          features = [
          ];
          wallpaper = { url = ""; sha256 = ""; };
          colorscheme = "gruvbox";
        };
      };
    };
}
