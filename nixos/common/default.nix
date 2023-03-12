# This file applies to all hosts
{ system, hostname, pkgs, ... }: {
  imports = [
    ./doas.nix
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

  programs = {
    git.enable = true; # Make nix work
    fuse.userAllowOther = true; # Allow root on impermanence binds
  };

  environment = {
    pathsToLink = [ "/share/zsh" ]; # For zsh-completions
    sessionVariables.EDITOR = "nvim"; # Override nano default TODO do with hm

    persistence."/persist" = {
      directories = [ "/var/lib/systemd/coredump" "/var/log" ];
    };
    enableAllTerminfo = true;
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.05";
}
