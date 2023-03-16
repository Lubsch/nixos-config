{ pkgs, inputs , system, ... }: {
  nix = {
    # TODO change this when its the default in pkgs, required for xdg dirs
    package = pkgs.nixVersions.nix_2_14;
    
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
      use-xdg-base-directories = true;
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ 
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
    '';
    gc = {
      automatic = true;
      dates = "weekly";
    };

    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  nixpkgs = {
    hostPlatform = { inherit system; };
    config = { 
      allowUnfree = true; 
      enableParallelBuilding = true;
    };
  };

}
