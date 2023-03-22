{ lib, inputs, ... }@args:
if ((args ? host) && args.host.specialArgs.impermanence) then { 
  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];
} else {
  options.home.persistence = lib.mkOption { };
}
