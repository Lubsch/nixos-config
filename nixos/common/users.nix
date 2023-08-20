{ lib, config, pkgs, inputs, ... }: {

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.my-users = lib.mkOption { default = {}; };

  config =
  let keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+woFGMkb7kaOxHCY8hr6/d0Q/HIHIS3so7BANQqUe6" # arch
  ]; in {

    users = {
      mutableUsers = false;
      users = (users: if users == {} then {
        root.openssh.authorizedKeys = { inherit keys; };
      } else users) (builtins.mapAttrs (name: _: {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "libvirtd" ];
        openssh.authorizedKeys = { inherit keys; };
        passwordFile = "/persist/passwords/${name}";
      }) config.my-users);
    };

    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      useGlobalPkgs = true;
      useUserPackages = true;
      users = builtins.mapAttrs (name: modules: {
        imports = modules ++ [ { home.username = name; } ];
      }) config.my-users;
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
    '') config.my-users;

  };
}
