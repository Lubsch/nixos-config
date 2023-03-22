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
  let hosts = import ./hosts.nix; in {

    templates = import ./templates;
    packages = import ./pkgs nixpkgs;

    nixosConfigurations = builtins.mapAttrs
      (hostname: host: nixpkgs.lib.nixosSystem 
        (host // { specialArgs = { inherit hostname inputs; }; }))
      hosts;

    homeConfigurations = with builtins; zipAttrsWith
      (_: user: head user)
      (attrValues (mapAttrs
        (hostname: host: nixpkgs.lib.mapAttrs'
          (username: user: {
            name = "${username}@${hostname}";
            value = home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.${host.specialArgs.system};
              inherit (user) modules;
              extraSpecialArgs = { inherit host username inputs; };
            };
          })
          host.specialArgs.users)
        hosts));
  };
}
