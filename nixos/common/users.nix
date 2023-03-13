{ pkgs, users, ... }: {
  users = {
    users = builtins.mapAttrs
      (username: user: {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [
          "wheel"
          "video"
          "audio"
          "networkmanager"
          "libvirtd"
        ];
        openssh.authorizedKeys.keys = user.authorizedKeys;
        # TODO Make this work without /persist existing, too
        passwordFile = "/persist/passwords/${username}";
      })
      users;

    mutableUsers = false;
  };

  home-manager = {
    users = builtins.mapAttrs (_: user: user.hm-config) users;
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
