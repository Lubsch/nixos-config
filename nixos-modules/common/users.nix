{ pkgs, config, users, ... }:
let
  makeUser = user: {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ] ++ builtins.filter (group: builtins.hasAttr group config.users.group) [
      "network"
      "libvirtd"
      "git"
    ];

    openssh = { inherit (user.arguments) authorizedKeys; };
    /* passwordFile = user.arguments.passwordPath; */
  };
in
{
  users.mutableUsers = false;
  users.users = builtins.mapAttrs makeUser users;
}
