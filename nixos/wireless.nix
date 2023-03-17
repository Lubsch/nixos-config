# TODO switch from networkmanager to something more lightweight
{
  networking.networkmanager.enable = true;

  environment.persistence."/persist".directories = [ 
    "/etc/NetworkManager/system-connections" 
  ];
}
