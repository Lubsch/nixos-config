{ lib, ... }: {
  options.persist = lib.mkOption {};
  options.setup-scripts = lib.mkOption {};

  config = {
    systemd.user.startServices = "sd-switch";
    home.stateVersion = "23.05";
  };
}
