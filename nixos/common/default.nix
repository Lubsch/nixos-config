{ pkgs, cpuVendor, hostname, ... }: {
  imports = map (f: ./. + "/${f}")
    ((builtins.filter (f: f != "default.nix")) (builtins.attrNames (builtins.readDir ./.)));

  system.stateVersion = "23.05";
  networking.hostName = hostname;
  time.timeZone = "Europe/Berlin";
  environment.enableAllTerminfo = true;
  environment.binsh = "${pkgs.dash}/bin/dash";

  hardware = {
    enableRedistributableFirmware = true;
  } // (if (cpuVendor != "") then {
    cpu.${cpuVendor}.updateMicrocode = true;
  } else { });

  persist.directories = [
    "/var/lib/systemd/coredump"
    "/var/log"
  ];
}
