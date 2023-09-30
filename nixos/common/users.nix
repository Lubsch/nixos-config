{ lib, config, pkgs, inputs, ... }: {

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = 
  let 
    keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+woFGMkb7kaOxHCY8hr6/d0Q/HIHIS3so7BANQqUe6" # arch
    ]; 
  in {

    users = {
      mutableUsers = false;
      defaultUserShell = pkgs.zsh;
      allowNoPasswordLogin = true;
      users = if config.home-manager.users == {} then {
        root.openssh.authorizedKeys = { inherit keys; };
      } else builtins.mapAttrs (_: _: {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        # openssh.authorizedKeys = { inherit keys; };
      }) config.home-manager.users;
    };

    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      useGlobalPkgs = true;
      useUserPackages = true;
    };

    # Set user passwords on activation if not yet set
    system.activationScripts.passwords.text = builtins.concatStringsSep "\n" (
      map (name: let 
        file = lib.optionalString (config.fileSystems ? "/persist") "/persist" + "/etc/passwords/${name}";
      in ''
        if [ ! -f ${file} ]; then
          mkdir -m 600 $(dirname ${file})
          printf "Enter new ${name} "
          ${pkgs.mkpasswd}/bin/mkpasswd > ${file}
        fi
        usermod ${name} -p $(cat ${file})
      '') (builtins.attrNames config.home-manager.users)
    );

  };
}
