{ pkgs
, inputs
, lib
, ...
}:
let
  inherit (lib) mapAttrs' nameValuePair;
  toRegistry = mapAttrs' (n: v: nameValuePair n { flake = v; });
in
{
  nix = {
    settings = {
      substitutors = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
    };
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';
    gc = {
      automatic = true;
      dates = "weekly";
    };
    # Map flakes to system registries (the features that enables nixpkgs#hello)
    registry = toRegistry inputs;
  };
}
