{ config, ... }: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 350;
        offset = "20x40";
        padding = 8;
        frame_width = 0;
        font = "${config.fonts.regular.name} 12";
      };
      urgency_normal = {
        background = "#000000d8";
        foreground = "#c4c4c4";
        timeout = 5;
      };
    };
  };
}
