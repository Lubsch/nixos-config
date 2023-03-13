{ hostname, ... }:
let
  decrypted-drive = "/dev/mapper/${hostname}";
  wipeScript = ''
    mkdir -p /btrfs
    mount -o subvol=/ "${decrypted-drive}" /btrfs

    if [ -e "/btrfs/root/dontwipe" ]; then
      echo "P: Not wiping root because the file /btrfs/root/dontwipe exists"
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
    rm /btrfs
  '';
in
{
  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];
    postDeviceCommands = wipeScript;
  };

  fileSystems = {
    "/" = {
      device = "${decrypted-drive}";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

    "/nix" = {
      device = "${decrypted-drive}";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" "compress=zstd" ];
    };

    "/persist" = {
      device = "${decrypted-drive}";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

    "/swap" = {
      device = "${decrypted-drive}";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 8196;
  }];
}
