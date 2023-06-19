{ hostname, lib, swap, impermanence, ... }@args:
let
  # Pass main-drive as an argument if you don't want encryption
  main-drive = if (args ? main-drive)
    then args.main-drive
    else "/dev/mapper/${hostname}";

  wipeScript = ''
    mkdir -p /mnt
    mount -o subvol=/ "${main-drive}" /mnt

    btrfs subvolume delete /mnt/root-old
    btrfs subvolume snapshot /mnt/root /mnt/root-old

    btrfs subvolume list -o /mnt/root | awk '{print $NF}' |
    while read -r subvolume; do
      btrfs subvolume delete /mnt/$subvolume
    done && btrfs subvolume delete /mnt/root

    btrfs subvolume snapshot /mnt/root-blank /mnt/root

    umount /mnt
  '';
in
{
  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];
    postDeviceCommands = lib.mkIf impermanence wipeScript;
    luks.devices."${hostname}".device = lib.mkIf (!(args ? main-drive))
      "/dev/disk/by-partlabel/${hostname}_crypt";
  };

  fileSystems = {
    "/" = {
      device = "${main-drive}";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

    "/nix" = {
      device = "${main-drive}";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    "/persist" = lib.mkIf impermanence {
      device = "${main-drive}";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

    "/swap" = {
      device = "${main-drive}";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    inherit (swap) size;
  }];
  boot = {
    resumeDevice = main-drive;
    kernelParams = [ "resume_offset=${swap.offset}" ];
  };
  services.logind.lidSwitch = "hybrid-sleep";

  # For automount
  services.udisks2.enable = true;
}
