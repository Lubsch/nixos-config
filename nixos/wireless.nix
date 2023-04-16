{
  networking.wireless.iwd.enable = true;

  environment.persistence."/persist".directories = [ 
    "/var/lib/iwd"
  ];
}
