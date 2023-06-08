{ hostname, lib, swap, impermanence, ... }@args:
let
  main-drive = if (args ? main-drive)
    then args.main-drive
    else "/dev/mapper/${hostname}";

  wipeScript = ''
    mkdir -p /btrfs
    mount -o subvol=/ "${main-drive}" /btrfs

    if [ -e "/btrfs/root/dontwipe" ]; then
      echo "P: The file /btrfs/root/dontwipe exists"
    else
      echo "P: Cleaning subvolume"
      btrfs subvolume list -o /btrfs/root | cut -f9 -d ' ' |
      while read subvolume; do
        btrfs subvolume delete "/btrfs/$subvolume"
      done && btrfs subvolume delete /btrfs/root

      echo "P: Restoring blank subvolume"
      btrfs subvolume snapshot /btrfs/root-blank /btrfs/root
    fi

    umount /btrfs
    rmdir /btrfs
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
      options = [ "subvol=nix" "noatime" "compress=zstd" ];
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
