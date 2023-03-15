{ config, pkgs, inputs, users, impermanence, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
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
        users;
    };
    home-manager = {
      extraSpecialArgs = { inherit inputs impermanence; };
      useGlobalPkgs = true;
      useUserPackages = true;

      users = builtins.mapAttrs 
        (username: user: {
          inherit (user) imports;
          _module.args = { inherit username; }; })
        users;
  };
}
