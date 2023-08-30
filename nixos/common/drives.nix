{ lib, config, inputs, ... }: {

  imports = [ inputs.disko.nixosModules.disko ];

  options = {
    swap = {
      size = lib.mkOption { default = null; };
      offset = lib.mkOption { default = ""; };
    };
    main-disk = lib.mkOption {};
  };

  config = {

    services.logind.lidSwitch = "hybrid-sleep";
    swapDevices = [ {
      device = "/swap/swapfile";
      size = config.swap.size * 1024;
    } ];
    boot = lib.mkIf (config.swap.size != null){
      resumeDevice = config.main-disk;
      kernelParams = [ "resume_offset=${config.swap.offset}" ];
    };

    system.activationScripts.swap-config = lib.mkIf (config.swap.size == null) ''
      echo You haven't configured swap. Paste this:
      echo swap = { size = CHANGE; offset = \"$(doas btrfs inspect-internal map-swapfile -r /swap/swapfile)\"; }
    '';

    boot.initrd.supportedFilesystems = [ "btrfs" ];

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
