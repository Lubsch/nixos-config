{ pkgs, ... }:
let
  lubsch-zonefile = pkgs.writeText "lubsch.de.zone" ''
    $TTL 86400
    @   IN  SOA ns.lubsch.de. admin.example.com. (
            2024111901 ; Serial
            3600       ; Refresh
            1800       ; Retry
            604800     ; Expire
            86400      ; Negative Cache TTL
    )
    ;
    @   IN  NS  ns.lubsch.de.
    ns  IN  A   127.0.0.1
    www IN  A   127.0.0.1
  '';
in
{
  services.knot = {
    enable = true;
    settingsFile =
      pkgs.writeText "knot.conf" # yaml
        ''
          # Example of a very simple Knot DNS configuration.

          server:
              listen: 0.0.0.0@53
              listen: ::@53

          zone:
            - domain: lubsch.de
              storage: /var/lib/knot/zones/
              file: ${lubsch-zonefile}

          log:
            - target: syslog
              any: info
        '';
  };
}
