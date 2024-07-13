{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;

    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  # Passwordless sudo when SSHing with keys
  # security.pam.enableSSHAgentAuth = true;

  persist.files = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_ed25519_key.pub"
  ];
}
