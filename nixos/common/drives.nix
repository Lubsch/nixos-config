{ inputs, hostname, lib, swap, impermanence, main-disk, ... }:
let
  # TODO keep multiple root-old generations
  # If anything goes wrong, stderror still gets shown
  wipeScript = ''
    mkdir -p /mnt
    mount -o subvol=/ "/dev/mapper/main" /mnt

    btrfs subvolume delete /mnt/root-old > /dev/null
    btrfs subvolume snapshot /mnt/root /mnt/root-old > /dev/null

    btrfs subvolume list -o /mnt/root | awk '{print $NF}' |
    while read -r subvolume; do
      btrfs subvolume delete /mnt/$subvolume > /dev/null
    done && btrfs subvolume delete /mnt/root > /dev/null

    btrfs subvolume create /mnt/root > /dev/null
    umount /mnt
  '';
in
{
  imports = [ inputs.disko.nixosModules.disko ];

  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];
    postDeviceCommands = lib.mkIf impermanence wipeScript;
  };

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
    size = swap.size * 1024;
  }];
  boot = {
    resumeDevice = main-disk;
    kernelParams = [ "resume_offset=${swap.offset}" ];
  };
  services.logind.lidSwitch = "hybrid-sleep";

  # Automount
  services.udisks2.enable = true;
}
