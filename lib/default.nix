{ inputs, ... }:
let
  inherit (inputs) self home-manager nixpkgs;
  inherit (self) outputs;

  inherit (builtins) elemAt match any mapAttrs attrValues;
  inherit (nixpkgs.lib) nixosSystem genAttrs mapAttrs';
  inherit (home-manager.lib) homeManagerConfiguration;
in
rec {
  # Applies a function to an attrset's names while keeping the values
  mapAttrNames = f:
    mapAttrs' (name: value: {
      name = f name;
      inherit value;
    });

  has = element: any (x: x == element);

  getUsername = string: elemAt (match "(.*)@(.*)" string) 0;
  getHostname = string: elemAt (match "(.*)@(.*)" string) 1;

  systems = [
    "aarch64-linux"
    "x86_64-linux"
  ];
  forAllSystems = genAttrs systems;

  importAttrset = path: mapAttrs (_: import) (import path);

  mkSystem =
    { hostname
    , system
    , persistence ? false
    ,
    }:
    nixosSystem {
      inherit system;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      specialArgs = {
        inherit inputs outputs hostname persistence;
      };
      modules =
        attrValues (import ../modules/nixos)
        ++ [
          ../hosts/${hostname}
          inputs.home-manager.nixosModules.home-manager
        ];
    };

  mkHome =
    { username
    , hostname ? null
    , system ? outputs.nixosConfiguration.${hostname}.pkgs.system
    , persistence ? false
    , colorscheme ? null
    , wallpaper ? null
    , features ? [ ]
    }:
    homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs outputs hostname username persistence wallpaper features;
      };
      modules =
        attrValues (import ../modules/home-manager)
        ++ [
          ../home/${username}
        ];
    };
}
