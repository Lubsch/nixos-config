{ pkgs
, lib
, config
, nixpkgs
, ...
}:
{
  nix = {
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
      # TODO readd this after nix update
      # use-xdg-base-directories = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
    '';
    gc = {
      automatic = true;
      dates = "weekly";
    };
    # Map nixpkgs to registry (when using e.g. `nix run nixpkgs#asdf`, it defines what nixpkgs it)
    registry.nixpkgs.flake = nixpkgs;

    # Map registry to channel (useful when using legacy commands)
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
}
