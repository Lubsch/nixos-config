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

    openssh.authorizedKeys.keys = user.authorizedKeys;
    passwordFile = "/etc/passwords/${username}";
  };

in {
  users = {
    users = builtins.mapAttrs makeSystemUser users;
    mutableUsers = false;
  };

  home-manager = {
    users = builtins.mapAttrs (_: user: user.hm-config) users;
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # NOTE maybe make this use more secure permissions one day
  environment.persistence."/persist".directories = [ "/etc/passwords" ];
}
