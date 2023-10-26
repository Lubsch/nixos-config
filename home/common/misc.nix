{ lib, ... }: {
  options.persist = lib.mkOption {};
  config = {
    systemd.user.startServices = "sd-switch";
    home.stateVersion = "23.05";
  };
}
