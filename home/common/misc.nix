{ lib, config, ... }:
{
  options.persist = lib.mkOption {
    type = lib.types.attrsOf (lib.types.listOf lib.types.anything);
  };
  config = {
    home.activation.installPackages = false; # Don't remove home-manager profile which we never generate
    systemd.user.startServices = "sd-switch";
    home.homeDirectory = lib.mkForce "/home/lubsch";
    home.username = lib.mkForce "lubsch";
    home.stateVersion = "23.05";
  };
}
