{ pkgs, cpuVendor, hostname, ... }: {
  imports = with builtins; map (f: ./. + "/${f}")
    ((filter (f: f != "default.nix")) (attrNames (readDir ./.)));

  system.stateVersion = "23.05";
  networking.hostName = hostname;
  time.timeZone = "Europe/Berlin";
  environment.enableAllTerminfo = true;
  environment.binsh = "${pkgs.dash}/bin/dash";

  hardware = {
    enableRedistributableFirmware = true;
    cpu.${cpuVendor}.updateMicrocode = true;
  };

  persist.directories = [
    "/var/lib/systemd/coredump"
    "/var/log"
  ];
}
