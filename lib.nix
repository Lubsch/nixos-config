{ inputs }:
let
  inherit (inputs) nixpkgs home-manager agenix impermanence firefox-addons nix-colors;
in
rec {

  # Flake input modules are alway imported (because the performance impact is small)

  makeNixosConfiguration = { hostname, host }:
    nixpkgs.lib.nixosSystem {
      pkgs = nixpkgs.legacyPackages.${host.arguments.system};
      modules = host.modules ++ [
        impermanence.nixoModules.impermanence
        agenix.nixosModules
        { config._module.args = host.arguments // { inherit hostname; }; }
      ];
    };

  makeHomeConfiguration = { hostname, host, username, user }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${host.arguments.system};
      modules = user.modules ++ [

        { config._module.args = host.arguments // user.arguments // {
          inherit hostname username;
          firefox-addons = firefox-addons.packages.${host.arguments.system};
          inherit (nix-colors) colorSchemes;
        }; }
      ];
    };

  makeNixosConfigurations = hosts:
    builtins.mapAttrs
      (hostname: host: makeNixosConfiguration { inherit hostname host; })
      hosts;

  makeHomeConfigurations = hosts:
    builtins.mapAttrs
      (hostname: host: builtins.mapAttrs
        (username: user: makeHomeConfiguration { inherit hostname host username user; })
        host.users)
      hosts;
}
