{ lib, inputs, impermanence, config, ... }: 
if impermanence then {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    (lib.mkAliasOptionModule [ "persist" ] [ "environment" "persistence" "/persist" ] )
  ];
} else {
  options.persist = lib.mkOption { };
}
