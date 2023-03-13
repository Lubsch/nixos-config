{ pkgs, users, inputs, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

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
        openssh.authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+woFGMkb7kaOxHCY8hr6/d0Q/HIHIS3so7BANQqUe6" # arch
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvuIIrh2iuj2hX0zIzqLUC/5SD/ZJ3GaLcI1AyHDQuM" # droid
        ];
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
