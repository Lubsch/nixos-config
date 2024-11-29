{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    (lib.mkAliasOptionModule [ "persist" ] [
      "environment"
      "persistence"
      "/persist"
    ])
  ];

  # special case for /etc/machine-id which we need for journald early in boot
  # symlink to /persist/etc/machine-id
  # should work because /persist is "neededForBoot"
  boot.initrd.systemd.services.persist-machine-id = {
    description = "Create symlink to /persist/etc/machine-id early in boot";
    after = [ "create-needed-for-boot-dirs.service" ];
    wantedBy = [ "initrd.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      touch /script-starting
      ln -snfT /persist-tmp-mnt/persist/etc/machine-id /etc/machine-id
      touch /script-stopping
    '';
  };

  home-manager.sharedModules = [
    (
      { config, lib, ... }:
      {
        imports = [
          inputs.impermanence.nixosModules.home-manager.impermanence
          (lib.mkAliasOptionModule [ "persist" ] [
            "home"
            "persistence"
            "/persist${config.home.homeDirectory}"
          ])
        ];
        persist.allowOther = true;
      }
    )
  ];

  programs.fuse.userAllowOther = true;

  systemd.tmpfiles.rules = map (name: "d /persist/home/${name} 0700 lubsch users") (
    lib.attrNames config.home-manager.users
  );

  # See ./common/drives.nix
  extraSubvolumes."/persist" = {
    mountpoint = "/persist";
    mountOptions = [
      "compress=zstd"
      "noatime"
    ];
  };
  fileSystems."/persist".neededForBoot = true;

  # TODO keep old snapshots
  # boot.initrd.systemd.services.wipe-root = {
  #   wantedBy = [ "initrd.target" ];
  #   after = [ "systemd-cryptsetup@main.service" ];
  #   before = [ "sysroot.mount" ];
  #   unitConfig.DefaultDependencies = "no";
  #   serviceConfig.Type = "oneshot";
  #   script = ''
  #     mkdir -p /mnt
  #     mount -o subvol=/ "/dev/mapper/main" /mnt
  #
  #     if [ -f /mnt/root-old ]; then
  #       btrfs subvolume delete /mnt/root-old
  #       btrfs subvolume snapshot /mnt/root /mnt/root-old > /dev/null
  #     fi
  #
  #     btrfs subvolume list -o /mnt/root | cut -f9 -d ' ' |
  #     while read -r subvolume; do
  #       btrfs subvolume delete /mnt/$subvolume > /dev/null
  #     done && btrfs subvolume delete /mnt/root > /dev/null
  #
  #     btrfs subvolume create /mnt/root
  #     umount /mnt
  #   '';
  # };
}
