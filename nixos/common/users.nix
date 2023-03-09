{ pkgs, config, users, ... }:
let
  existingGroupsFrom = builtins.filter (group: builtins.hasAttr group config.users.groups);

  makeSystemUser = username: user: {
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

in {
  users = {
    users = builtins.mapAttrs makeSystemUser users;
    mutableUsers = false;
  };

  home-manager = {
    users = builtins.mapAttrs (_: user: user.hm-config) users;
    useGlobalPkgs = true;
  };
}
