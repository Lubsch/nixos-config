# This file applies to all hosts
{ lib
, inputs
, ...
}: {
  imports = [
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./agenix.nix
  ];

  nixpkgs = {
    overlays = import ../../overlays;
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
