{
  # enable chrony instead of systemd's timesyncd to prevent waiting on startup
  services.chrony = {
    enable = true;
    serverOption = "offline";
  };

  services.ntp.enable = false;
}
