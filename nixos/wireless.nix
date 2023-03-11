{
  networking.networkmanager.enable = true;

  # Make the group exist
  users.groups.networkmanager = { };

  environment.persistence."/persist".directories = [ 
    "/etc/NetworkManager/system-connections" 
  ];
}
