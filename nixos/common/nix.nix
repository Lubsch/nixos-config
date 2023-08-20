{ lib, config, pkgs, inputs, ... }: {

  # Required for nix command
  environment."${if config.droid then "p" else "systemP"}ackages" = [ pkgs.git ];

  nix = {
    extraOptions = ''
      use-xdg-base-directories = true
      warn-dirty = false
      auto-optimise-store = true
      experimental-features = nix-command flakes repl-flake
    '';

    registry = lib.mkIf (!config.droid) {
      n.flake = inputs.nixpkgs;
      nixpkgs.flake = inputs.nixpkgs;
      config.flake.outPath = ../..;
    };

    gc = lib.mkIf (!config.droid) {
      automatic = true;
      dates = "weekly";
    };
  };

  nixpkgs = lib.mkIf (!config.droid) {
    config = {
      allowUnfree = true; 
      enableParallelBuilding = true;
    };
  };
}
