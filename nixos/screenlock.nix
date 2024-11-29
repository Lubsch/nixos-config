let
  sleep-fix = {
    serviceConfig.Environment="SYSTEMD_SLEEP_FREEZE_USER_SESSIONS=false";
  };
in {
  services.logind.lidSwitch = "suspend";

  # systemd.services.systemd-suspend = sleep-fix;
  # systemd.services.systemd-hibernate = sleep-fix;
  # systemd.services.systemd-suspend-then-hibernate = sleep-fix;

  systemd.sleep.extraConfig = "SuspendState=freeze";

  security.pam.services.swaylock = { };
  security.pam.services.waylock = { };
  security.pam.services.hyprlock = { };
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.swaylock ];
        programs.hyprlock = {
          enable = true;
          settings = {

            general = {
              hide_cursor = true;
              no_fade_in = true;
              immediate_render = true;
            };

            background = [
              {
                path = "~/pictures/wallpapers/current";
                blur_passes = 3;
                blur_size = 8;
              }
            ];

            input-field = [
              {
                hide_input = true;
                # size = "200, 50";
                # position = "0, -80";
                # monitor = "";
                # dots_center = true;
                # fade_on_empty = false;
                # font_color = "rgb(202, 211, 245)";
                # inner_color = "rgb(91, 96, 120)";
                # outer_color = "rgb(24, 25, 38)";
                # outline_thickness = 5;
                # placeholder_text = "Password...";
                # shadow_passes = 2;
              }
            ];
          };
        };
        services.swayidle =
          let
            command = "${pkgs.hyprlock}/bin/hyprlock";
          in
          {
            enable = true;
            events = [
              {
                event = "before-sleep";
                inherit command;
              }
            ];
            # timeouts = [ { timeout = 60; inherit command; } ];
          };
      }
    )
  ];
}
