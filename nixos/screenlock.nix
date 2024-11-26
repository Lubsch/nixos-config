{
  services.logind.lidSwitch = "suspend";

  security.pam.services.swaylock = { };
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.swaylock ];
        services.swayidle =
          let
            command = "${pkgs.swaylock}/bin/swaylock";
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
