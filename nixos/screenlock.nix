{
  services.logind.lidSwitch = "suspend";

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
              no_fade_out = true;
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
        services.hypridle = {
            enable = true;
            settings.general.before_sleep_cmd = "${pkgs.hyprlock}/bin/hyprlock";
        };
      }
    )
  ];
}
