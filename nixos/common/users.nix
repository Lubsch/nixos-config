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
        extraGroups = [ "wheel" "network" "ydotool" ];
        # openssh.authorizedKeys = { inherit keys; };
      }) config.home-manager.users;
    };

    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      useGlobalPkgs = true;
      useUserPackages = true;
    };

    # Set user passwords on activation if not yet set
    # Can't use impermanence binds, so saves in /persist if impermanence is on
    system.activationScripts.user-passwords.text = lib.concatLines (lib.mapAttrsToList 
      (name: _: 
        let
          file = "/persist/etc/passwords/${name}";
        in ''
          if [ ! -f ${file} ]; then
            mkdir -p "$(dirname ${file})"
            echo "Set the user password for ${name}"
            ${pkgs.mkpasswd}/bin/mkpasswd > ${file}
            chmod 600 ${file}
          fi
          usermod ${name} -p "$(cat ${file})"
        '')
      config.home-manager.users);

  };
}
