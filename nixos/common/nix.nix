{ pkgs, inputs, ... }: {

  # Required for nix command
  environment.systemPackages = [ pkgs.git ];

  nix = {
    package = pkgs.nixVersions.latest; # for features like showing packages as their path

    extraOptions = ''
      use-xdg-base-directories = true
      warn-dirty = false
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';

    settings.trusted-users = [ "@wheel" ];

    registry = {
      n.flake = inputs.nixpkgs;
      nixpkgs.flake = inputs.nixpkgs;
      c.flake.outPath = ../..;
    };

    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  nixpkgs.config = {
    allowUnfree = true; 
    enableParallelBuilding = true;
  };
}
