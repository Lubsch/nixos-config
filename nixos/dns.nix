{ pkgs, ... }:
{
  services.knot = {
    enable = true;
    settingsFile = pkgs.writeText "knot.conf" ''
      # Example of a very simple Knot DNS configuration.

      server:
          listen: 0.0.0.0@53
          listen: ::@53

      zone:
        - domain: lubsch.de
          storage: /var/lib/knot/zones/
          # file: lubsch.de.zone

      log:
        - target: syslog
          any: info
    '';
  };
}
