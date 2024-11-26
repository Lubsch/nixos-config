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
    boot.tmp.useTmpfs = true;
    swapDevices = [
      {
        device = "/swap/swapfile";
        size = config.swap-size * 1024;
      }
    ];
    disko.devices.nodev."/" = {
      fsType = "tmpfs";
    };
    disko.devices.disk.main = {
      type = "disk";
      device = config.main-disk;
      content = {
        type = "gpt";
        partitions = {
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
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "main";
              extraOpenArgs = [ "--allow-discards" ];
              content = {
                type = "btrfs";
                subvolumes = config.extraSubvolumes // {
                  # "/root" = {
                  #   mountpoint = "/";
                  #   mountOptions = [
                  #     "compress=zstd"
                  #     "noatime"
                  #   ];
                  # };
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
  };
}
