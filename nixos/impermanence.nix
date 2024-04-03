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

  system.activationScripts.create-persist-homes = {
    text = lib.concatLines (lib.mapAttrsToList (name: _: ''
      mkdir -p /persist/home/"${name}"
      chown "${name}" /persist/home/"${name}"
    '') config.home-manager.users);
    deps = [ "users" ];
  };

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
