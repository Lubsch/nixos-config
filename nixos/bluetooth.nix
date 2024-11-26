{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # prevent warning about wrong mode of config dir
  systemd.tmpfiles.rules = [
    "d /etc/bluetooth 555 root root"
  ];
}
