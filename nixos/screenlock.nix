{ lib, config, pkgs, ... }: {
  options.swap.offset = lib.mkOption { default = ""; };

  config = {
    services.logind.lidSwitch = "hybrid-sleep";

    boot = lib.mkIf (config.swap.size != null) {
      resumeDevice = config.fileSystems."/".device;
      kernelParams = [ "resume_offset=${config.swap.offset}" ];
    };

    system.activationScripts.setup-swap = lib.mkIf (config.swap.offset == "") ''
      echo "Note: You haven't configured swap resume offset."
      echo "Paste this to flake.nix:"
      echo "swap = { size = CHANGE; offset = \"$(${pkgs.btrfs-progs}/bin/btrfs inspect-internal map-swapfile -r /swap/swapfile)\"; };"
    '';

    security.pam.services.swaylock = {};
    home-manager.sharedModules = [ ({ pkgs, ... }: {
      services.swayidle =
      let
        command = "${pkgs.swaylock}/bin/swaylock";
      in {
        enable = true;
        events = [ { event = "before-sleep"; inherit command; } ];
        # timeouts = [ { timeout = 60; inherit command; } ];
      };
    }) ];
  };
}
