{ config, ... }: {
  programs.adb.enable = true;
  users.users = builtins.mapAttrs (_: _: {
    extraGroups = [ "adbusers" ];
  }) config.home-manager.users;
}
