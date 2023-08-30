{ lib, inputs, ... }: {

  imports = [
    inputs.impermanence.nixosModules.impermanence
    (lib.mkAliasOptionModule [ "persist" ] [ "environment" "persistence" "/persist" ])
  ];

  home-manager.sharedModules = [
    inputs.impermanence.nixosModules.home-manager.impermanence 
    ({ config, ... }: { 
      imports = [ (lib.mkAliasOptionModule [ "persist" ] [ "home" "persistence" "/persist${config.home.homeDirectory}" ]) ];
      persist.allowOther = true; 
    })
  ];

  programs.fuse.userAllowOther = true;

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
