{ lib, inputs, impermanence, ... }: 
if impermanence then {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    (lib.mkAliasOptionModule [ "persist" ] [ "environment" "persistence" "/persist" ] )
  ];
  programs.fuse.userAllowOther = true;
} else {
  options.persist = lib.mkOption { };
}
