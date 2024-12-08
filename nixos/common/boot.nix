# has also accumulated config for speeding up startup
{ pkgs, ... }:
{

  hardware.enableRedistributableFirmware = true;

  # Remove welcome line from getty
  environment.etc.issue.text = "";

  # Remove (unnecessary, I hope) delay from waiting for network
  systemd.targets.network-online.enable = false;
  systemd.sockets.systemd-hostnamed.enable = false;
  systemd.services.systemd-timesyncd.after = "default.target";
  networking.dhcpcd.wait = "background";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      systemd.enable = true; # experimental, for concurrent stage 1
      verbose = false;
    };
    kernelParams = [
      "quiet"
      "i8042.unlock=1"
    ]; # i8042 option to get rid of harmless keyboard warning that it's locked
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
