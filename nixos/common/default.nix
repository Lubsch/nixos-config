# This file applies to all hosts
{ lib, hostname, pkgs, ... }: {
  imports = [
    ./btrfs-optin-persistence.nix
    ./doas.nix
    ./encrypted-root.nix
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./systemd-boot.nix
    ./users.nix
  ];

  networking = {
    useDHCP = false;
    hostName = hostname;
  };

  nixpkgs = {
    hostPlatform = pkgs.system;
    config = { 
      allowUnfree = true; 
      enableParallelBuilding = true;
    };
  };

  environment = {
    persistence."/persist" = {
      directories = [ "/var/lib/systemd" "/var/log" ];
      files = [ "/etc/machine-id" ];
    };
    enableAllTerminfo = true;
  };

  # Allows other users (includeing root) on fuse binds (used by impermanence)
  programs.fuse.userAllowOther = true;

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.05";
}
