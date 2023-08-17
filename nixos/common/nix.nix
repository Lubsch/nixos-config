{ config, pkgs, inputs, ... }: {

  # Required for nix command
  environment."${if config.droid then "p" else "systemP"}ackages" = [ pkgs.git ];

  nix = {
    extraOptions = ''
      use-xdg-base-directories = true
      warn-dirty = false
      auto-optimise-store = true
      experimental-features = nix-command flakes repl-flake
    '';

   #registry.n.flake = inputs.nixpkgs;
   #registry.nixpkgs.flake = inputs.nixpkgs;
   #registry.config.flake.outPath = ../..;
  } // (if config.droid then {} else {
    gc = {
      automatic = true;
      dates = "weekly";
    };
  });

 #nixpkgs = {
 #  config = {
 #    allowUnfree = true; 
 #    enableParallelBuilding = true;
 #  };
 #};
}
