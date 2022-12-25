{ pkgs
, inputs
, lib
, config
, ...
}:
{
  nix = {
    settings = {
      auto-optimise-store = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
    };
    # Map each flake input as a registry, making nix commands consistent with the flake
    # (where it is defined what 'nixpkgs' means)
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Map registry to channel (useful when using legacy commands)
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
}
