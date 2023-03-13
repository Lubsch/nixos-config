{ hostname, ... }: {
  boot.initrd = {
    luks.devices."${hostname}".device = "/dev/disk/by-partlabel/${hostname}_crypt";
  };
}
