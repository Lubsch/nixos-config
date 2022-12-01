# This file and the global directory as a whole apply to all hosts
{ lib
, inputs
, outputs
, ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./users.nix
  ];

  programs.zsh.enable = true;

  # Persist logs etc.
  environment.persistence."/persist".directories = [ "/var/lib/systemd" "/var/log" ];

  # Allows users to allow others on their binds (fuse binds are used by persistence)
  programs.fuse.userAllowOther = true;

  hardware.enableRedistributableFirmware = true;
}
