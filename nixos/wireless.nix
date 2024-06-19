{ config, ... }: {
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  persist.directories = [
    "/etc/NetworkManager/system-connections"
  ];

  users.users = builtins.mapAttrs (_: _: {
    extraGroups = [ "network" ];
  }) config.home-manager.users;

  # TODO automate this
  # eduroam:
  # https://www.tu.berlin/en/campusmanagement/it-support/wlan-eduroam-setup-in-linux
  # security: wpa & wpa2 enterprise
  # authentication: PEAP
  # anonymous-identity: wlan@<domain>
  # MSCHAPv2
  # username: <name>@<domain>
}
