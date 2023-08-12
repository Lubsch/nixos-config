{ pkgs, inputs, impermanence, users ? {}, ... }:
let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+woFGMkb7kaOxHCY8hr6/d0Q/HIHIS3so7BANQqUe6" # arch
  ]; 
in
if (users != {}) then {

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  users = {
    mutableUsers = false;
    users = builtins.mapAttrs (name: _: {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "libvirtd" ];
      openssh.authorizedKeys = { inherit keys; };
      passwordFile = "/persist/passwords/${name}";
    }) users;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs impermanence; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = builtins.mapAttrs (name: imports: {
      inherit imports;
      _module.args = { username = name; }; 
    }) users;
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
  '') users;

} else {
  users.users.root.openssh.authorizedKeys = { inherit keys; };
}
