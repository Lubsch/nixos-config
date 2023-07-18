{ lib, impermanence ? false, inputs, ... }:
if impermanence then { 
  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];
} else {
  options.home.persistence = lib.mkOption { };
}
