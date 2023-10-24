{ pkgs, inputs, ... }: {

  # Required for nix command
  environment.systemPackages = [ pkgs.git ];

  nix = {
    extraOptions = ''
      use-xdg-base-directories = true
      warn-dirty = false
      auto-optimise-store = true
      experimental-features = nix-command flakes repl-flake
    '';

    settings = {
      trusted-substituters = [ "https://helix.cachix.org" ];
      trusted-public-keys = [ "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs=" ];
      trusted-users = [ "@wheel" ];
    };

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
