{ lib, config, ... }:
{
  options.persist = lib.mkOption {
    type = lib.types.attrsOf (lib.types.listOf lib.types.anything);
  };
  config = {
    # TODO figure out way to remove config attribute alltogether
    home.activation.installPackages = lib.mkForce ""; # Don't remove home-manager profile which we never generate
    systemd.user.startServices = "sd-switch";
    home.stateVersion = "23.05";
  };
}
