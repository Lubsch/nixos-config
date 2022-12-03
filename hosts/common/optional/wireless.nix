{ config, lib, ... }: {
  /* # Secrets stored with sops */
  /* sops.secrets.wireless = { */
  /*   sopsFile = ../secrets.yaml; */
  /*   neededForUsers = true; */
  /* }; */

  networking.wireless = {
    enable = true;
    fallbackToWPA2 = false;
    # Declarative networking config
    /* environmentFile = config.sops.secrets.wireless.path; */
    /* networks = { */
    /*   "FRITZ!Box 7590 TC" = { */
    /*     psk = "@FRITZ@"; */
    /*   }; */
    /* }; */

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
