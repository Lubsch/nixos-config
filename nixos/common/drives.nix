{ lib, config, inputs, ... }: {

  imports = [ inputs.disko.nixosModules.disko ];

  options = {
    swap = {
      size = lib.mkOption { default = 0; };
      offset = lib.mkOption { default = ""; };
    };
    main-disk = lib.mkOption {};
  };

  config = {

    boot.initrd.supportedFilesystems = [ "btrfs" ];

    services.logind.lidSwitch = "hybrid-sleep";
    swapDevices = [ {
      device = "/swap/swapfile";
      size = config.swap.size * 1024;
    } ];
    boot = {
      resumeDevice = config.main-disk;
      kernelParams = [ "resume_offset=${config.swap.offset}" ];
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
              mountOptions = [ "defaults" ];
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
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = [ "compress=zstd" "noatime" ];
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
    fileSystems."/persist".neededForBoot = true;

  };
}
