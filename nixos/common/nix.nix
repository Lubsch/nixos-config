{ pkgs, inputs, ... }: {

  # Required for nix command
  environment.systemPackages = [ pkgs.git ];

  nix = {
    extraOptions = ''
      use-xdg-base-directories = true
      warn-dirty = false
      auto-optimise-store = true
      experimental-features = nix-command flakes repl-flake
      builders-use-substitutes = true
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

    distributedBuilds = true;
    # buildMachines = [ {
    #   hostName = "raja";
    #   system
    # } ];
  };

  nixpkgs.config = {
    allowUnfree = true; 
    enableParallelBuilding = true;

    # "nixos-config" requires it (cve)
    permittedInsecurePackages = [
      "nix-2.15.3"
    ];

  };
}
