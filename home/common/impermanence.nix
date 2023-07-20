{ lib, impermanence, inputs, config, ... }: 
if impermanence then {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence 
    (lib.mkAliasOptionModule [ "persist" ] [ "home" "persistence" "/persist${config.home.homeDirectory}" ] )
  ];
} else {
  options.persist = lib.mkOption { };
}
