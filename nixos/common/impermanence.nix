{ lib, impermanence, inputs, ...}: 
if impermanence then {
  imports = [ inputs.impermanence.nixosModules.impermanence ];
} else {
  options.environment.persistence = lib.mkOption { };
}
