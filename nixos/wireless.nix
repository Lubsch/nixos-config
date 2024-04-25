# { config, ... }: {
#   networking.wireless = {
#     enable = true;
#     allowAuxiliaryImperativeNetworks = true;
#     userControlled = {
#       enable = true;
#     };
#   };
#
#   persist.files = [ 
#     "/etc/wpa_supplicant.conf"
#   ];
#
#   # has to exist first, or service can't start
#   systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";
# }
{
  networking.networkmanager.enable = true;
}
