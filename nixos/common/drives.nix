{ inputs, swap, main-disk, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  boot.initrd.supportedFilesystems = [ "btrfs" ];

  disko.devices.disk.main = {
    type = "disk";
    device = main-disk;
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

  swapDevices = [{
    device = "/swap/swapfile";
    size = (swap.size or 0) * 1024;
  }];
  boot = {
    resumeDevice = main-disk;
    kernelParams = [ "resume_offset=${swap.offset or ""}" ];
  };
  services.logind.lidSwitch = "hybrid-sleep";
}
