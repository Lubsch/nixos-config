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
      mkHost = { hostname, architecture }: nixpkgs.lib.nixosSystem {
        pkgs = legacyPackages.${architecture};
        specialArgs = { inherit inputs outputs; };
        modules = [ (./hosts + "/${hostname}") ];
      };
      mkHome = { username, hostname, architecture }: home-manager.lib.homeManagerConfiguration {
          pkgs = legacyPackages.${architecture};
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ (./home + "/${username}/${hostname}.nix") ];
        };

      templates = import ./templates;
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      overlays = import ./overlays;

      legacyPackages = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = with overlays; [  ];
          config.allowUnfree = true;
        }
      );

      packages = forAllSystems (system:
        import ./pkgs { pkgs = legacyPackages.${system}; }
      );

      devShells = forAllSystems (system: {
        default = import ./shell.nix { pkgs = legacyPackages.${system}; };
      });

      nixosConfigurations = {
        # Laptop
        duke = mkHost { hostname = "duke"; architecture = "x86_64-linux"; };

        # Desktop
        /* king = mkHost { hostname = "king"; architecture = "x86_64-linux"; }; */

        /* # Server */
        /* serf = mkHost { hostname = "serf"; architecture = "aarch64-linux"; }; */

        /* # Phone */
        /* earl = mkHost { hostname = "earl"; architecture = "aarch64-linux"; }; */
      };

      homeConfigurations = {
        # Laptop
        "lubsch@duke" = mkHome { username = "lubsch"; hostname = "duke"; architecture = "x86_64-linux"; };

        # Desktop
        /* "lubsch@king" = mkHome { username= "lubsch"; hostname = "king"; architecture = "x86_64-linux"; }; */

        /* # Server */
        /* "lubsch@serf" = mkHome { username = "lubsch"; hostname = "serf"; architecture = "aarch64-linux"; }; */

        /* # Phone */
        /* "lubsch@earl" = mkHome { username = "lubsch"; hostname = "earl"; architecture = "aarch64-linux"; }; */
      };
    };
}
