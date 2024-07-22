{ pkgs, ... }:
{
  services.logind.lidSwitch = "suspend-then-hibernate";

  security.pam.services.swaylock = { };
  environment.systemPackages = [ pkgs.swaylock ];
  systemd.services.lock = {
    description = "run swaylock before sleeping";
    wantedBy = [ "pre-sleep.service" ];
    script = ''
      swaylock
    '';
    serviceConfig.type = "oneshot";
  };
}
