{ lib, config, inputs, ... }: {

  imports = [
    inputs.impermanence.nixosModules.impermanence
    (lib.mkAliasOptionModule [ "persist" ] [ "environment" "persistence" "/persist" ])
  ];

  home-manager.sharedModules = [
    inputs.impermanence.nixosModules.home-manager.impermanence 
    ({ config, ... }: { 
      imports = [ 
        (lib.mkAliasOptionModule [ "persist" ] [ "home" "persistence" "/persist${config.home.homeDirectory}" ])
      ];
      persist.allowOther = true; 
    })
  ];

  system.activationScripts.create-persist-homes.text = let
    script-per-user = (name: ''
      mkdir -p /persist/home/"${name}"
      chown "${name}" /persist/home/"${name}"
    '');
  in builtins.concatStringsSep "\n" (map script-per-user (builtins.attrNames config.home-manager.users));

  programs.fuse.userAllowOther = true;

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

}
