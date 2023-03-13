{
  services.openssh = {
    enable = true;

    settings = {
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

  environment.persistence."/persist".files = [ 
    "/etc/ssh/ssh_host_ed25519_key" "/etc/ssh/ssh_host_ed25519_key.pub"
  ];

  # Passwordless sudo when SSHing with keys
  security.pam.enableSSHAgentAuth = true;
}
