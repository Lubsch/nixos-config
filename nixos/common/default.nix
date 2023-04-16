{ lib, cpu, hostname, ... }: {
  imports = builtins.filter (n: n != ./default.nix) 
    (lib.filesystem.listFilesRecursive ./.);

  system.stateVersion = "23.05";

  networking.hostName = hostname;
  time.timeZone = "Europe/Berlin";

  powerManagement.cpuFreqGovernor = cpu.freq;
  hardware = {
    enableRedistributableFirmware = true;
    cpu.${cpu.vendor}.updateMicrocode = true;
  };

  environment = {
    sessionVariables.EDITOR = "nvim"; # Override nano default, TODO do with hm
    enableAllTerminfo = true;

    persistence."/persist".directories = [
      "/var/lib/systemd/coredump"
      "/var/log"
    ];
  };
}
