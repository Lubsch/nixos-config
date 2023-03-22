{ config, pkgs, inputs, impermanence, ... }@args:
if (args ? users) then {
  users = {
    mutableUsers = false;

    users = builtins.mapAttrs
      (username: user: {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [
          "wheel"
          "networkmanager"
          "libvirtd"
        ];
        openssh.authorizedKeys = { inherit (config) keys; };
        # TODO Make this work without /persist existing, too
        passwordFile = "/persist/passwords/${username}";
      })
      args.users;
  };
} else {
  users.users.root.openssh.authorizedKeys = { inherit (config) keys; };
}
