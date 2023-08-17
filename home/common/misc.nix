{ lib, username, ... }: {
  options.persist = lib.mkOption {};
  options.setup-scripts = lib.mkOption {};

  config = {
    systemd.user.startServices = "sd-switch";
    home = lib.mkDefault {
      inherit username;
      homeDirectory = "/home/${username}";
      stateVersion = "23.05";
    };
  };
}
