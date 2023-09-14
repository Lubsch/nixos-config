{ lib, config, pkgs, inputs, ... }: {

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
    swapDevices = lib.mkIf (config.swap.size != null) [ {
      device = "/swap/swapfile";
      size = config.swap.size * 1024;
    } ];
    boot = lib.mkIf (config.swap.size != null) {
      resumeDevice = config.main-disk;
      kernelParams = [ "resume_offset=${config.swap.offset}" ];
    };

    system.activationScripts.setup-swap = lib.mkIf (config.swap.size == null) ''
      echo "Note: You haven't configured swap."
      echo "Paste this to flake.nix:"
      echo "swap = { size = CHANGE; offset = \"$(${pkgs.btrfs-progs}/bin/btrfs inspect-internal map-swapfile -r /swap/swapfile)\"; };"
    '';

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
