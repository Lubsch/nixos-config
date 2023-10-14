{ lib, config, pkgs, ... }: {

  options.swap = {
    size = lib.mkOption { default = null; };
    offset = lib.mkOption { default = ""; };
  };

  config = {
    services.logind.lidSwitch = "suspend-then-hibernate";
    swapDevices = lib.mkIf (config.swap.size != null) [ {
      device = "/swap/swapfile";
      size = config.swap.size * 1024;
    } ];
    boot = lib.mkIf (config.swap.size != null) {
      resumeDevice = config.fileSystems."/".device;
      kernelParams = [ "resume_offset=${config.swap.offset}" ];
    };

    system.activationScripts.setup-swap = lib.mkIf (config.swap.offset == "") ''
      echo "Note: You haven't configured swap."
      echo "Paste this to flake.nix:"
      echo "swap = { size = CHANGE; offset = \"$(${pkgs.btrfs-progs}/bin/btrfs inspect-internal map-swapfile -r /swap/swapfile)\"; };"
    '';
  };

}
