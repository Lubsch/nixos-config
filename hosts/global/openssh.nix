{
  services.openssh = {
    enable = true;
    # Hardenings :)
    passwordAuthentication = false;
    permitRootLogin = "no";
    # Remove stale sockets automatically
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
    # Allow ssh clients to connect to ports open to host (port forwarding)
    gatewayPorts = "clientspecified";

    hostKeys = [{
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  # Passwordless sudo when SSHing with keys
  security.pam.enableSSHAgentAuth = true;
}
