{ lib, impermanence, inputs, ... }:
if impermanence then { 
  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];
  programs.fuse.userAllowOther = true; # Allow root on impermanence binds
} else {
  options.home.persistence = lib.mkOption { };
}
