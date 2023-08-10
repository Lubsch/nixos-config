{ pkgs, ... }: {
  virtualisation.libvirtd.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];

  persist.directories = [
    "/var/lib/libvirt/images"
  ];
}
