# This file applies to all hosts
{ cpuFreqGovernor, cpu-vendor, system, hostname, ... }: {
  imports = [
    ./doas.nix
    ./nix.nix
    ./openssh.nix
    ./boot.nix
    ./users.nix
  ];

  hardware = {
    enableRedistributableFirmware = true;
    cpu.${cpu-vendor}.updateMicrocode = true;
  };
  powerManagement = {inherit cpuFreqGovernor; };
  system.stateVersion = "23.05";

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
    hostPlatform = { inherit system; };
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
    etc."zshenv".text = ''export ZDOTDIR="$HOME"/.config/zsh''; # Source zshenv without ~/.zshenv
    pathsToLink = [ "/share/zsh" ]; # Make zsh-completions work
    sessionVariables.EDITOR = "nvim"; # Override nano default, TODO do with hm
    enableAllTerminfo = true;

    persistence."/persist" = {
      directories = [ "/var/lib/systemd/coredump" "/var/log" ];
    };
  };
}
