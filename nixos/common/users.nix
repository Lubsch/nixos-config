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
    passwordFile = config.age.secrets.userPassword.path;
  };
in
{
  age.secrets.userPassword.file = ../../secrets/userPassword.age;
  users.mutableUsers = false;
  users.users = builtins.mapAttrs makeUser users;
}
