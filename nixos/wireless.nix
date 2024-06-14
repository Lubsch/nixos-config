{
  # networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;

  # persist.directories = [
  #   "/etc/NetworkManager/system-connections"
  # ];
  
  persist.directories = [
    "/var/lib/iwd"
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
