# TODO switch from networkmanager to something more lightweight
{
  networking.wireless.iwd.enable = true;

  environment.persistence."/persist".directories = [ 
    "/var/lib/iwd"
  ];
}
