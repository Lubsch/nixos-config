{ config, ... }: {
  # Configure network manager for imperative usage
  networking.networkmanager.enable = true;

  # Make the group exist
  users.groups.networkmanager = { };

  # Persist imperative config
  environment.persistence."/persist".directories = [ "/etc/NetworkManager/system-connections" ];
}
