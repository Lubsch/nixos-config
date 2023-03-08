{ pkgs, config, users, ... }:
let
  existingGroupsFrom = builtins.filter (group: builtins.hasAttr group config.users.groups);
  makeUser = username: user: {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ] ++ existingGroupsFrom [
      "networkmanager"
      "libvirtd"
    ];

    # Not in root directory or /etc because it's not a standard linux directory but my own
    passwordFile = "/persist/passwords/${username}";

    openssh.authorizedKeys.keys = user.authorizedKeys;
  };
in
{
  users = {
    # Make users from "users" argument to the hosts's config
    users = builtins.mapAttrs makeUser users;
    mutableUsers = false;
  };
}
