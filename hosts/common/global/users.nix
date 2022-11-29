{ pkgs
, config
, lib
, ...
}: {
  users.mutableUsers = false;
  users.users = {
    lubsch = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups =
        [
          "wheel"
          "video"
          "audio"
        ]
        ++ (lib.optional config.networking.networkmanager.enable "networkmanager")
        ++ (lib.optional config.hardware.i2c.enable "i2c")
        ++ (lib.optional config.services.minecraft-server.enable "minecraft")
        ++ (lib.optional config.virtualisation.libvirtd.enable "libvirtd");

      openssh.authorizedKeys.keys = [
      ];
    };
  };
}
