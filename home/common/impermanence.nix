{ lib, inputs, impermanence, config, ... }: 
if impermanence then {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence 
    (lib.mkAliasOptionModule [ "persist" ] [ "home" "persistence" "/persist${config.home.homeDirectory}" ] )
  ];
  config.persist.allowOther = true; # Access to binds for root
} else {
  options.persist = lib.mkOption { };
}
