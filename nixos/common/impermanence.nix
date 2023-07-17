{ lib, impermanence ? true, inputs, ...}: 
if impermanence then {
  imports = [ inputs.impermanence.nixosModules.impermanence ];
  programs.fuse.userAllowOther = true; # Allow root on impermanence binds
} else {
  options.environment.persistence = lib.mkOption { };
}
