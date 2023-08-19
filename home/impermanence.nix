{ lib, inputs, config, ... }: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence 
    (lib.mkAliasOptionModule [ "persist" ] [ "home" "persistence" "/persist${config.home.homeDirectory}" ])
  ];
}
