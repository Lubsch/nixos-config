{ inputs }:
let
  # Flake input modules are always imported because why not
  inherit (inputs) nixpkgs home-manager agenix impermanence firefox-addons nix-colors;

  # Terce usage of builtins
  inherit (builtins) map attrValues mapAttrs listToAttrs concatLists;

  makeNixosConfiguration = { hostname, host }:
    nixpkgs.lib.nixosSystem {
      pkgs = nixpkgs.legacyPackages.${host.arguments.system};
      modules = host.modules ++ [
        impermanence.nixosModules.impermanence
        agenix.nixosModule
        { config._module.args = host.arguments // { inherit hostname; }; }
      ];
    };

  makeHomeConfiguration = { hostname, host, username, user }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${host.arguments.system};
      modules = user.modules ++ [
        impermanence.nixosModules.home-manager.impermanence
        { config._module.args = host.arguments // user.arguments // {
          inherit hostname username;
          inherit (nix-colors) colorSchemes;
          firefox-addons = firefox-addons.packages.${host.arguments.system};
        }; }
      ];
    };

	makeUsersOnHost = (hostname: host:
		map
			(hmConfig: { name = "${hmConfig.config.home.username}@${hostname}"; value = hmConfig; })
			(attrValues
				(mapAttrs
					(username: user: makeHomeConfiguration { inherit hostname host username user; })
					host.arguments.users
				)
			)
		);


in {
  makeNixosConfigurations = hosts:
    mapAttrs
      (hostname: host: makeNixosConfiguration { inherit hostname host; })
      hosts;

  makeHomeConfigurations = hosts: 
  	listToAttrs (concatLists (attrValues (mapAttrs
		makeUsersOnHost
		hosts
	)));
}
