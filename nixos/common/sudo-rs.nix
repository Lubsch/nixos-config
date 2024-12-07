{
  security.sudo-rs = {
    enable = true;
    wheelNeedsPassword = false;
    execWheelOnly = true;
  };
  security.doas = {
    enable = true;
    wheelNeedsPassword = false;
  };
  # security.sudo = {
  #   enable = true;
  #   wheelNeedsPassword = false;
  #   execWheelOnly = true;
  # };
}
