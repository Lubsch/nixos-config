{ lib, config, inputs, ... }: {

  imports = [
    inputs.impermanence.nixosModules.impermanence
    (lib.mkAliasOptionModule [ "persist" ] [ "environment" "persistence" "/persist" ])
  ];

  home-manager.sharedModules = [ ({ config, lib, ... }: {
    imports = [
      inputs.impermanence.nixosModules.home-manager.impermanence 
      (lib.mkAliasOptionModule [ "persist" ] [ "home" "persistence" "/persist${config.home.homeDirectory}" ])
    ];
    persist.allowOther = true; 
  }) ];

  programs.fuse.userAllowOther = true;

  systemd.tmpfiles.rules = [
    "D /home/lubsch/asdf 0700 lubsch users"
  ];
  # systemd.tmpfiles.rules = map
  #   (name: "d /persist/home/${name} 0700 lubsch users")
  #   (lib.attrNames config.home-manager.users);

  # See ./common/drives.nix
  extraSubvolumes."/persist" = {
    mountpoint = "/persist";
    mountOptions = [ "compress=zstd" "noatime" ];
  };
  fileSystems."/persist".neededForBoot = true;

  # TODO keep old snapshots
  boot.initrd.postDeviceCommands = ''
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
}
