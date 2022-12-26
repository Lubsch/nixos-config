{ home-manager, nixpkgs }:
let
  makeNixosConfiguration = { hostname, host }:
    nixpkgs.lib.nixosSystem {
      pkgs = nixpkgs.legacyPackages.${host.system};
      _module.args = host // { inherit hostname; };
      inherit (host) modules;
    };

  makeHomeConfiguration = { hostname, host, username, user }:
    home-manager.lib.homeManagerConfiguration {
      _module.args = host // user // { inherit hostname username; };
      inherit (user) modules;
    };
in
{
  makeNixosConfigurations = hosts:
    builtins.mapAttrs
      (hostname: hosts: makeNixosConfiguration { inherit hostname host; })
      hosts;

  makeHomeConfigurations = hosts:
    builtins.mapAttrs
      (hostname: hosts: builtins.mapAttrs
        (username: user: makeHomeConfiguration { inherit hostname host username user; })
        host.users)
      hosts;
}
