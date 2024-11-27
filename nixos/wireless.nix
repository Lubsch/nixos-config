{
  networking.wireless.enable = false;
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  persist.directories = [ "/etc/NetworkManager/system-connections" ];

  # see nixos/users.nix where network group is added

  # TODO automate this
  # eduroam:
  # https://www.tu.berlin/en/campusmanagement/it-support/wlan-eduroam-setup-in-linux
  # security: wpa & wpa2 enterprise
  # authentication: PEAP
  # anonymous-identity: wlan@<domain>
  # MSCHAPv2
  # username: <name>@<domain>
}
