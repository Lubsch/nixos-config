# This file applies to all hosts
{ cpuFreqGovernor, system, hostname, ... }: {
  imports = [
    ./doas.nix
    ./nix.nix
    ./openssh.nix
    ./boot.nix
    ./users.nix
  ];

  system.stateVersion = "23.05";
  hardware.enableRedistributableFirmware = true;
  powerManagement = {inherit cpuFreqGovernor; };

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
    hostPlatform.system = system;
    config = { 
      allowUnfree = true; 
      enableParallelBuilding = true;
    };
  };

  programs = {
    git.enable = true; # Make nix work
    fuse.userAllowOther = true; # Allow root on impermanence binds
  };

  environment = {
    enableAllTerminfo = true;
    pathsToLink = [ "/share/zsh" ]; # Make zsh-completions work
    sessionVariables.EDITOR = "nvim"; # Override nano default TODO do with hm

    persistence."/persist" = {
      directories = [ "/var/lib/systemd/coredump" "/var/log" ];
    };
  };
}
