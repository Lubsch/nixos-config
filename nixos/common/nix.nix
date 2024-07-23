{
  pkgs,
  inputs,
  config,
  ...
}:
{

  # Required for nix command
  environment.systemPackages = [ pkgs.git ];

  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      ${config.nix.package}/bin/nix store diff-closures /run/current-system "$systemConfig"
    fi
  '';

  nix = {
    package = pkgs.lix; # for features like showing packages as their path

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

  nixpkgs.config.enableParallelBuilding = true;
}
