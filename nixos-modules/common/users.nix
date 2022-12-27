{ pkgs, config, users, ... }:
let
  makeUser = username: user: {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ] ++ builtins.filter (group: builtins.hasAttr group config.users.groups) [
      "network"
      "libvirtd"
      "git"
    ];

    openssh = { authorizedKeys.keys = user.arguments.authorizedKeys; };
    /* passwordFile = user.arguments.passwordPath; */
  };
in
{
  users.mutableUsers = false;
  users.users = builtins.mapAttrs makeUser users;
}
