{ cpuFreqGovernor, cpu-vendor, hostname, users, ... }: {
  imports = [
    ./doas.nix
    ./nix.nix
    ./openssh.nix
    ./boot.nix
  ] ++ [ (if (users != null) then ./users.nix else ./only-root.nix) ];

  hardware = {
    enableRedistributableFirmware = true;
    cpu.${cpu-vendor}.updateMicrocode = true;
  };

  networking = {
    useDHCP = false;
    hostName = hostname;
  };

  console.useXkbConfig = true;
  services.xserver = {
    layout = "de";
    xkbOptions = "caps:escape";
  };

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
