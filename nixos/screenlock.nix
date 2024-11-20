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
              disable_loading_bar = true;
              grace = 300;
              hide_cursor = true;
              no_fade_in = false;
            };

            background = [
              {
                path = "screenshot";
                blur_passes = 3;
                blur_size = 8;
              }
            ];

            input-field = [
              {
                size = "200, 50";
                position = "0, -80";
                monitor = "";
                dots_center = true;
                fade_on_empty = false;
                font_color = "rgb(202, 211, 245)";
                inner_color = "rgb(91, 96, 120)";
                outer_color = "rgb(24, 25, 38)";
                outline_thickness = 5;
                placeholder_text = "Password...";
                shadow_passes = 2;
              }
            ];
          };
        };
        services.swayidle =
          let
            command = "${pkgs.writeShellScriptBin "lock" ''
              ${pkgs.swaylock}/bin/swaylock
            ''}/bin/lock";
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
