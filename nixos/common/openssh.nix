{
  services.openssh = {
    enable = true;

    # Hardenings :)
    passwordAuthentication = false;
    permitRootLogin = "no";

    # Allow ssh clients to connect to ports open to host (port forwarding)
    gatewayPorts = "clientspecified";

    # Remove stale sockets automatically
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';

    hostKeys = [{
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  # Perstist host key across reboots
  environment.persistence."/persist".files = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # Passwordless sudo when SSHing with keys
  security.pam.enableSSHAgentAuth = true;
}
