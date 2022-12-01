# System config for the duke PC :)
{ pkgs
, inputs
, ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/optional/pipewire.nix
    ../common/optional/encrypted-root.nix
    ../common/optional/systemd-boot.nix
    ../common/optional/steam.nix
  ];

  networking = {
    hostName = "duke";
    useDHCP = false;
  };

  programs.adb.enable = true;

  virtualisation.libvirtd = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [ virt-manager ];
  

  system.stateVersion = "22.05";
}
