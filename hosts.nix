{ nixos-modules, hm-modules }:
let
  authorizedKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDS42veAAS9JxykhqWAhJq/llMEqNWScUHeH7bbv6w7BhzEkhpokEtpq+Mkp1EM7zJgq5FIEQcuQtoEZkZpYqR+c8bAKXHkz8KDBvg4yI1Y5AjRd4vWistAMNicoatwLU5gaPsmhbFNE2HGPVEO+8pBMruSJy+fHAgESSWgn/GYGazv/qCohKPp/7Mw4pXdrdynMIsB7KbHtuXx/zn2+R1az0zfP7XWv9qiyniINrPGBwWMtyYqdNd0K4G1FBWNjfVwGCUw2W50/vX5B2y0FI/gLpzg6VSFksOiH9S8pAR/4vN71fnHZw7vOuFIFq8PSedgFjsTuarELNBWRuKMWIxmej/UChmtNEqMOLOSkHNv3LBLHFFFljoOnaIoCTgSAn2I5+yHsaEy/TWhi6D0nCYA1UQBB4mVeoElFoAM1FAOV7jaMSMKHMJhSrDXtFmpJGXf2eEGyuX467q+rhb/MgW7QtIkMaOvMYbH5kiz+gleZmQ5K73yu5xmrBz66G6Flgs= (lubsch@arch)"
  ];
in
{
  duke = {
    system = "x86_64-linux";
    kernelModules = [ "kvm-intel" ];
    initrdModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
    modules = with nixos-modules; [
      common
      users
      wireless
      virtualisation
      encrypted-root
      pipewire
    ];
    users = {
      lubsch = {
        inherit authorizedKeys;
        modules = with hm-modules; [
          common
          cli
          nvim
          desktop
        ];
      };
    };
  };
}
