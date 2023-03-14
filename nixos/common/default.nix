{ cpuFreqGovernor, cpu-vendor, hostname, users, lib, ... }: {
  imports = [
    ./doas.nix
    ./nix.nix
    ./openssh.nix
    ./boot.nix
  ] ++ lib.optional (users != null) ./users.nix 
  ++ lib.optional (users == null) ./only-root.nix;

  hardware = {
    enableRedistributableFirmware = true;
    cpu.${cpu-vendor}.updateMicrocode = true;
  };

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
    sessionVariables.EDITOR = "nvim"; # Override nano default, TODO do with hm
    enableAllTerminfo = true;

    persistence."/persist".directories = [
      "/var/lib/systemd/coredump" "/var/log" 
    ];
  };

  powerManagement = {inherit cpuFreqGovernor; };
  system.stateVersion = "23.05";
}
