{ lib, config, pkgs, inputs, mylib, ... }: {

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
      extraSpecialArgs = { inherit inputs mylib; };
      useGlobalPkgs = true;
      useUserPackages = true;
    };

    # Set user passwords on activation if not yet set
    system.activationScripts.passwords.text = let 
      dir = lib.optionalString (config.fileSystems ? "/persist") "/persist" + "/etc/passwords";
      script-per-user = (name: ''
        if [ ! -f ${dir}/${name} ]; then
          mkdir -p ${dir}
          printf "Enter new ${name} "
          ${pkgs.mkpasswd}/bin/mkpasswd > ${dir}/${name}
          chmod 600 ${dir}/${name}
        fi
        usermod ${name} -p $(cat ${dir}/${name})
      '');
    in builtins.concatStringsSep "\n" (map script-per-user (builtins.attrNames config.home-manager.users));

  };
}
