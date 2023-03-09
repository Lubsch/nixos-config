# This file applies to all hosts
{ lib, system, hostname, pkgs, ... }: {
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
    localSystem.system = system;
    config = { 
      allowUnfree = true; 
      enableParallelBuilding = true;
    };
  };

  environment = {
    # Makes root aware of git for nixos-rebuil --flake
    packages = [ git ];
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
