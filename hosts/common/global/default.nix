# This file and the global directory as a whole apply to all hosts
{ lib
, inputs
, hostname
, persistence
, config
, ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./users.nix
  ];

  networking.hostName = hostname;

  programs.zsh.enable = true;

  # Persist logs etc.
  environment.persistence."/persist" = lib.mkIf persistence {
    hideMounts = true;
    directories = [ "/var/lib/systemd" "/var/log" ];
  };

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  system.stateVersion = lib.mkDefault "22.05";
}
