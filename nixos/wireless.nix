{ pkgs, ... }:
{
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = [ pkgs.gnome.networkmanager-openconnect ];

  # see nixos/users.nix where network group is added

  persist.directories = [ "/etc/NetworkManager/system-connections" ];

  # TODO automate this
  # eduroam:
  # https://www.tu.berlin/en/campusmanagement/it-support/wlan-eduroam-setup-in-linux
  # security: wpa & wpa2 enterprise
  # authentication: PEAP
  # anonymous-identity: wlan@<domain>
  # MSCHAPv2
  # username: <name>@<domain>
}
