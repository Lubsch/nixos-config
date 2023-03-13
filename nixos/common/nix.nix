{ inputs , ... }: {
  nix = {
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
      # TODO add this after nix update
      # use-xdg-base-directories = true;
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
}
