{
  services.openssh = {
    enable = true;

    settings = {
      # Hardenings ig :)
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };

    # Remove stale sockets automatically
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';

    hostKeys = [{
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  # Persist host key across reboots
  environment.persistence."/persist".files = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # Passwordless sudo when SSHing with keys
  security.pam.enableSSHAgentAuth = true;
}
