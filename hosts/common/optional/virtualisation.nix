{ pkgs, ... }: {
  virtualisation.libvirtd.enable = true;
  envronment.systemPackages = with pkgs; [ virt-manager ];
}
