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
      "networkmanager"
      "libvirtd"
      "git"
    ];

    openssh.authorizedKeys.keys = user.authorizedKeys;

    # Not in root directory or /etc because it's not a standard linux directory but my own
    passwordFile = "/persist/passwords/${username}";
  };
in
{
  users = {
    # Make users from "users" argument to the hosts's config
    users = builtins.mapAttrs makeUser users;
    mutableUsers = false;
  };
}
