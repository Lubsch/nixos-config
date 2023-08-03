{ pkgs, cpuVendor, hostname, ... }: {
  imports = map (f: ./. + "/${f}")
    ((builtins.filter (f: f != "default.nix")) (builtins.attrNames (builtins.readDir ./.)));

  system.stateVersion = "23.05";
  networking.hostName = hostname;
  time.timeZone = "Europe/Berlin";
  environment.enableAllTerminfo = true;
  environment.binSh = "${pkgs.dash}"/bin/dash;

  hardware = {
    enableRedistributableFirmware = true;
    cpu.${cpuVendor}.updateMicrocode = true;
  };

  persist.directories = [
    "/var/lib/systemd/coredump"
    "/var/log"
  ];
}
