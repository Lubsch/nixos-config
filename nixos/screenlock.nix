{
  services.logind.lidSwitch = "suspend";

  security.pam.services.swaylock = { };
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.hyprlock ];
        services.swayidle =
          let
            command = "${pkgs.swaylock}/bin/hyprlock";
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
