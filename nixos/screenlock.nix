{
  services.logind.lidSwitch = "suspend-then-hibernate";

  security.pam.services.swaylock = { };
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.swaylock ];
        systemd.user.services.lock = {
          Unit.Description = "Lock screen before sleeping";
          Install.WantedBy = [ "pre-sleep.service" ];
          Service.ExecStart = "${pkgs.writeShellScriptBin "pre-sleep-lock" ''
            ${pkgs.playerctl}/bin/playerctl pause
            ${pkgs.swaylock}/bin/swaylock
          ''}";
        };
      }
    )
  ];
}
