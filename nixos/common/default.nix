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

  # TODO change this to something not involving xserver option
  services.xserver = {
    layout = "de";
    xkbOptions = "caps:escape";
  };
  console.useXkbConfig = true;

  nixpkgs = {
    localSystem.system = system;
    config = { 
      allowUnfree = true; 
      enableParallelBuilding = true;
    };
  };

  environment = {
    # Makes root aware of git for nixos-rebuild --flake
    systemPackages = [ pkgs.git ];
    # So zsh completion files are available correctly (https://github.com/nix-community/home-manager/blob/master/modules/programs/zsh.nix)
    pathsToLink = [ "/share/zsh" ];

    # TODO do this using home.sessionVariables in /home/nvim/default.nix when it doesn't get overridden by nano
    sessionVariables.EDITOR = "nvim";

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
