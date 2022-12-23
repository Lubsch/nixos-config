{ config, lib, ... }: {
  # Secrets stored with sops
  sops.secrets.wireless = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  networking.wireless = {
    enable = true;
    fallbackToWPA2 = false;
    # Declarative networking config
    environmentFile = config.age.secrets.wireless.path;
    networks = {
      "@SSID_HOME@" = {
        psk = "@PSK_HOME@";
      };
    };

    # Imperative fallback
    allowAuxiliaryImperativeNetworks = true;
    userControlled = {
      enable = true;
      group = "network";
    };
    extraConfig = ''
      update_config=1
    '';
  };

  # Make the group exist
  users.groups.network = { };

  # Persist imperative config
  environment.persistence = {
    "/persist".files = [
      "/etc/wpa_supplicant.conf"
    ];
  };
}
