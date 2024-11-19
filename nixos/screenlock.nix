{
  services.logind.lidSwitch = "suspend";

  security.pam.services.swaylock = { };
  security.pam.services.waylock = { };
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.swaylock ];
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
