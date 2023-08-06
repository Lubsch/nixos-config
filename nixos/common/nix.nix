{ inputs, ... }: {

  programs.git.enable = true; # Required for nix command

  nix = {
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
      use-xdg-base-directories = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
    '';
    gc = {
      automatic = true;
      dates = "weekly";
    };

    registry.n.flake = inputs.nixpkgs;
    registry.config.flake.outPath = ../..;
  };

  nixpkgs.config = {
    allowUnfree = true; 
    enableParallelBuilding = true;
  };
}
