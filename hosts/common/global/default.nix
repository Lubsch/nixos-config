# This file and the global directory as a whole apply to all hosts
{ lib
, inputs
, outputs
, ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./sops.nix
  ];

  home-manager = {
    # Safe profiles to /etc/profiles instead of ~/.nix-profile
    useUserPackages = true;
    # Use the same nixpkgs as the whole system
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  programs.zsh.enable = true;

  # Persist logs etc.
  environment = {
    persistence."/persist".directories = [ "/var/lib/systemd" "/var/log" ];
    enableAllTerminfo = true;
  };

  # Allows users to allow others on their binds (fuse binds are used by persistence)
  programs.fuse.userAllowOther = true;

  hardware.enableRedistributableFirmware = true;
}
