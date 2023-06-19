{ myLib, cpu, hostname, ... }: {
  imports = myLib.getModules ./.;

  system.stateVersion = "23.05";

  networking.hostName = hostname;
  time.timeZone = "Europe/Berlin";

  powerManagement.cpuFreqGovernor = cpu.freq;
  hardware = {
    enableRedistributableFirmware = true;
    cpu.${cpu.vendor}.updateMicrocode = true;
  };

  environment = {
    enableAllTerminfo = true;

    persistence."/persist".directories = [
      "/var/lib/systemd/coredump"
      "/var/log"
    ];
  };
}
