{ config, pkgs, ... }: {
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  users.users = builtins.mapAttrs (_: _: {
    extraGroups = [ "wireshark" ];
  }) config.home-manager.users;
}
