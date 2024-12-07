{ lib, config, ... }:
{
  options.persist = lib.mkOption {
    type = lib.types.attrsOf (lib.types.listOf lib.types.anything);
  };
  config = {
    systemd.user.startServices = "sd-switch";
    home.homeDirectory = lib.mkForce "/home/lubsch";
    home.username = lib.mkForce "lubsch";
    home.stateVersion = "23.05";
  };
}
