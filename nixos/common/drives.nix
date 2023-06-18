{ hostname, lib, swap, impermanence, ... }@args:
let
  # Pass main-drive as an argument if you don't want encryption
  main-drive = if (args ? main-drive)
    then args.main-drive
    else "/dev/mapper/${hostname}";

  wipeScript = ''
    mkdir -p /tmp
    mntpoint=$(mktemp -d)
    mount -o subvol=/ "${main-drive}" "$mntpoint"

    subvolumes=$(btrfs subvolume list -o "$mntpoint/root" | awk '{print $NF}')
    for subvolume in subvolumes; do
      btrfs subvolume delete "$mntpoint/$subvolume"
    done && btrfs subvolume delete "$mntpoint/root"

    btrfs subvolume snapshot "$mntpoint/root" "$mntpoint/root-backup"
    # btrfs subvolume snapshot "$mntpoint/root-blank" "$mntpoint/root"

    umount "$mntpoint"
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
