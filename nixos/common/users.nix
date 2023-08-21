{ lib, config, pkgs, inputs, ... }: {

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config =
  let keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+woFGMkb7kaOxHCY8hr6/d0Q/HIHIS3so7BANQqUe6" # arch
  ]; in {

    users = {
      mutableUsers = false;
      users = if config.home-manager.users == {} then {
        root.openssh.authorizedKeys = { inherit keys; };
      } else builtins.mapAttrs (name: _: {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "libvirtd" ];
        openssh.authorizedKeys = { inherit keys; };
        passwordFile = "/persist/passwords/${name}";
      }) config.home-manager.users;
    };

    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      useGlobalPkgs = true;
      useUserPackages = true;
    };

    system.activationScripts = builtins.mapAttrs (name: _: ''
      mkdir -p /persist/home/"${name}"
      chown "${name}" /persist/home/"${name}"
      if [ ! -e /persist/passwords/"${name}" ]; then
        mkdir -p /persist/passwords
        chmod o=,g= /persist/passwords
        printf "Enter new ${name} "
        ${pkgs.mkpasswd}/bin/mkpasswd -m sha-512 > /persist/passwords/"${name}"
      fi
    '') config.home-manager.users;

  };
}
