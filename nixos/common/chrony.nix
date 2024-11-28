{
  # enable chrony instead of systemd's timesyncd to prevent waiting on startup
  # TODO investigate how accurate this is
  # and if i need to trigger chronyc online
  # services.chrony = {
  #   enable = true;
  #   serverOption = "offline";
  # };
  #
  # services.ntp.enable = false;
}
