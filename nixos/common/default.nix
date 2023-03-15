{ inputs, impermanence, cpu, hostname, users, ... }: {
  imports = [
    ./doas.nix
    ./nix.nix
    ./openssh.nix
    ./boot.nix
    ./drives.nix
  ] ++ [ (if (users != null) then ./users.nix else ./no-users.nix) 
    (if impermanence 
     then inputs.impermanence.nixosModules.impermanence 
     else ./no-impermanence.nix) ];

  hardware = {
    enableRedistributableFirmware = true;
    cpu.${cpu.vendor}.updateMicrocode = true;
  };
  powerManagement.cpuFreqGovernor = cpu.freq;

  networking = {
    useDHCP = false;
    hostName = hostname;
  };

  time.timeZone = "Europe/Berlin";

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

  system.stateVersion = "23.05";
}
