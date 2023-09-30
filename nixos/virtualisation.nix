{ config, pkgs, ... }: {
  virtualisation.libvirtd.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];
  users.users = builtins.mapAttrs (_: _: {
    extraGroups = [ "libvirtd" ];
  }) config.home-manager.users;

  persist.directories = [
    "/var/lib/libvirt/images"
  ];
}
