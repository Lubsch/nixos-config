{
  description = "The one configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pks/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      lib = import ./lib { inherit inputs; };
      inherit (lib) mkSystem mkHome importAttrset forAllSystems;
      mkHost = { hostname, architecture }: {
        pkgs = legacyPackages.${architecture};
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./hosts/${hostname} ];
      };
      mkHome = { hostname, architecture }: {
        pkgs = legacyPackages.${architecture};
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./home/lubsch/${hostname} ];
      };
    in
    {

      templates = import ./templates;

      devShells = forAllSystems (system: {
        default = inputs.nixpkgs.legacyPackages.${system}.callPackage ./shell.nix { };
      });

      nixosConfigurations = {
        # Laptop
        duke = mkHost { hostname = "duke"; architecture = "x86_64-linux"; };

        # Desktop
        king = mkHost { hostname = "king"; architecture = "x86_64-linux"; };

        # Server
        serf = mkHost { hostname = "serf"; architecture = "aarch64-linux"; };

        # Phone
        earl = mkHost { hostname = "earl"; architecture = "aarch64-linux"; };
      };

      homeConfigurations = {
        # Laptop
        "lubsch@duke" = mkHome { hostname = "duke"; architecture = "x86_64-linux"; };

        # Desktop
        "lubsch@king" = mkHome { hostname = "king"; architecture = "x86_64-linux"; };

        # Server
        "lubsch@serf" = mkHome { hostname = "serf"; architecture = "aarch64-linux"; };

        # Phone
        "lubsch@earl" = mkHome { hostname = "earl"; architecture = "aarch64-linux"; };
      };
    };
}
