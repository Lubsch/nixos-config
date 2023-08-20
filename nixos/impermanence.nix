{ lib, config, inputs, ... }: {

  imports = [
    inputs.impermanence.nixosModules.impermanence
    (lib.mkAliasOptionModule [ "persist" ] [ "environment" "persistence" "/persist" ])
  ];

  home-manager.users = builtins.mapAttrs (name: _: {
    imports = [
      inputs.impermanence.nixosModules.home-manager.impermanence 
      (lib.mkAliasOptionModule [ "persist" ] [ "home" "persistence" "/persist/home/${name}" ])
      { persist.allowOther = true; }
    ];
  }) config.my-users;

  programs.fuse.userAllowOther = true;

  # TODO keep old generations
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
