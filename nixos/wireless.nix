{ pkgs, config, ... }: {
  # networking.wireless.enable = false;
  # networking.wireless.iwd.enable = true;
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  environment.systemPackages = [ pkgs.networkmanagerapplet ];

  users.users = builtins.mapAttrs (_: _: {
    extraGroups = [ "networkmanager" ];
  }) config.home-manager.users;

  persist.directories = [
    "/etc/NetworkManager/system-connections"
    "/var/lib/iwd" # for storing eduroam
  ];

  # TODO automate this
  # eduroam:
  # https://www.tu.berlin/en/campusmanagement/it-support/wlan-eduroam-setup-in-linux
  # security: wpa & wpa2 enterprise
  # authentication: PEAP
  # anonymous-identity: wlan@<domain>
  # MSCHAPv2
  # username: <name>@<domain>
}
