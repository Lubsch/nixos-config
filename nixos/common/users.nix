{ pkgs, inputs, impermanence, users, ... }:
let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+woFGMkb7kaOxHCY8hr6/d0Q/HIHIS3so7BANQqUe6" # arch
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvuIIrh2iuj2hX0zIzqLUC/5SD/ZJ3GaLcI1AyHDQuM" # droid
  ]; 
in
if (users != {}) then {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
    users = {
      mutableUsers = false;

      users = builtins.mapAttrs
        (username: _: {
          isNormalUser = true;
          shell = pkgs.zsh;
          extraGroups = [ "wheel" "libvirtd" ];
          openssh.authorizedKeys = { inherit keys; };
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
} else {
  users.users.root.openssh.authorizedKeys = { inherit keys; };
}
