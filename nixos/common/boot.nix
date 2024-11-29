# has also accumulated config for speeding up startup
{ lib, pkgs, ... }:
{

  hardware.enableRedistributableFirmware = true;

  # Remove welcome line from getty
  environment.etc.issue.text = "";

  # Remove (unnecessary, I hope) delay from waiting for network
  systemd.targets.network-online.enable = lib.mkForce false;
  networking.dhcpcd.wait = "background";

  environment.etc."systemd/system-generators".mode = "0544";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      systemd.enable = true; # experimental, for concurrent stage 1
      verbose = false;
    };
    kernelParams = [ "quiet" ];
    consoleLogLevel = 2;

    kernel.sysctl."kernel.perf_event_paranoid" = 1; # for rr debugger

    # slows down boot by ca. 1s
    # binfmt.emulatedSystems = [ "aarch64-linux" ]; # cross compilation

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        consoleMode = "auto";
      };
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
  };
}
