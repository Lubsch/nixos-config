{ lib, config, inputs, ... }: {

  imports = [
    inputs.impermanence.nixosModules.impermanence
    (lib.mkAliasOptionModule [ "persist" ] [ "environment" "persistence" "/persist" ])
  ];

  config = {
    home-manager.sharedModules = [ ({ config, ... }: {
      imports = [
        inputs.impermanence.nixosModules.home-manager.impermanence 
        (lib.mkAliasOptionModule [ "persist" ] [ "home" "persistence" "/persist${config.home.homeDirectory}" ])
      ];
      persist.allowOther = true; 
    }) ];

    programs.fuse.userAllowOther = true;

    system.activationScripts.create-persist-homes = {
      text = lib.concatLines (lib.mapAttrsToList (n: _: ''
        mkdir -p /persist/home/"${n}"
        chown "${n}" /persist/home/"${n}"
      '') config.home-manager.users);
      deps = [ "users" ];
    };

    fileSystems."/persist".neededForBoot = true;
    extraSubvolumes."/persist" = {
      mountpoint = "/persist";
      mountOptions = [ "compress=zstd" "noatime" ];
    };

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
  };
}
