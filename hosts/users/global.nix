{ pkgs, config, lib, outputs, username, keys, ... }:
let ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.group) group;
in
{
  users.mutableUsers = false;
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ] ++ ifTheyExist [
      "network"
      "libvirtd"
      "git"
    ];

    openssh.authorizedKeys = { inherit keys; };
    passwordFile = config.age.secrets.userPassword.path;
  };
}
