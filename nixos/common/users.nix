{ pkgs, lib, inputs, ... }@arguments:
let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+woFGMkb7kaOxHCY8hr6/d0Q/HIHIS3so7BANQqUe6" # arch
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvuIIrh2iuj2hX0zIzqLUC/5SD/ZJ3GaLcI1AyHDQuM" # droid
  ]; 
in 
lib.mkMerge [

  (lib.mkIf (arguments.users == null) {
    users.users.root.openssh.authorizedKeys = { inherit keys; };
   })

  (lib.mkIf (arguments.users != null) {
    imports = lib.mkBefore [ inputs.home-manager.nixosModules.home-manager ];
    users = {
      mutableUsers = false;

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
          openssh.authorizedKeys = {inherit keys; };
          # TODO Make this work without /persist existing, too
          passwordFile = "/persist/passwords/${username}";
        })
        arguments.users;
    };
    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      useGlobalPkgs = true;
      useUserPackages = true;

      users = builtins.mapAttrs 
        (username: user: {
          inherit (user) imports;
          _module.args = { inherit username; }; })
        arguments.users;
    };
  })
]
