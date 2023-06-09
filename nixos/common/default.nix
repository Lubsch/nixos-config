{ cpu, hostname, ... }: {
  imports = map (f: ./. + "/${f}") 
    ((builtins.filter (f: f != "default.nix")) (builtins.attrNames (builtins.readDir ./.)));

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
