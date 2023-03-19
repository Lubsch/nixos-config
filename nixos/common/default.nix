{ lib, cpu, hostname, ... }: {
  imports = builtins.filter (n: n != "default.nix") (lib.listFilesRecursive ./.);

  hardware = {
    enableRedistributableFirmware = true;
    cpu.${cpu.vendor}.updateMicrocode = true;
  };
  powerManagement.cpuFreqGovernor = cpu.freq;

  networking.hostName = hostname;
  time.timeZone = "Europe/Berlin";

  console.useXkbConfig = true;
  services.xserver = {
    layout = "de";
    xkbOptions = "caps:escape,altwin:swap_lalt_lwin";
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
