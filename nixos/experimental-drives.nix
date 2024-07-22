{
  lib,
  config,
  inputs,
  ...
}:
{

  imports = [ inputs.disko.nixosModules.disko ];

  options = {
    main-disk = lib.mkOption { };
    extraSubvolumes = lib.mkOption { };
    swap-size = lib.mkOption { };
  };

  config = {
    swapDevices = [
      {
        device = "/swap/swapfile";
        size = config.swap-size * 1024;
      }
    ];
    fileSystems = {
      "/" = lib.mkForce {
        fsType = "tmpfs";
        device = "none";
        options = [
          "defaults"
          "size=2G"
          "mode=755"
        ];
      };
    };
    disko.devices.disk.main = {
      type = "disk";
      device = config.main-disk;
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02";
          };
          ESP = {
            label = "EFI";
            name = "ESP";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          btrfs = {
            size = "100%";
            content = {
              type = "btrfs";
              subvolumes = config.extraSubvolumes // {
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/swap" = {
                  mountpoint = "/swap";
                  mountOptions = [ "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };

}
