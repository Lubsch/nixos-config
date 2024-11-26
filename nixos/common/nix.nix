{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    # Required for nix command
    git
    # enter build containers
    cntr
  ];

  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      ${config.nix.package}/bin/nix store diff-closures /run/current-system "$systemConfig"
    fi
  '';

  nix = {
    package = pkgs.lix; # for features like showing packages as their path

    extraOptions = ''
      fallback = true
      use-xdg-base-directories = true
      warn-dirty = false
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';

    settings = {
      trusted-users = [ "@wheel" ];
      # substituters = [
      #   "https://buddy.mtv.tu-berlin.de/nix-cache"
      #   "https://mockingbird.mtv.tu-berlin.de/nix-cache"
      # ];
      # trusted-public-keys = [
      #   "buddy.mtv.tu-berlin.de:sAU8vPixv/kTzVRiNHpJbSpXHefs3tXCnxKtqzkItZw="
      #   "mockingbird.mtv.tu-berlin.de-1:baCbaUbG7PKcHaawcBSmR7TTeClKlhKEAs5R3EpRwrM="
      # ];
    };

    registry = {
      n.flake = inputs.nixpkgs;
      nixpkgs.flake = inputs.nixpkgs;
      c.flake.outPath = ../..;
    };

    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    # };
  };


  nixpkgs.config = {
    enableParallelBuilding = true;
    allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
    ];
  };
}
