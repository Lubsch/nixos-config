{ lib
, ...
}: {
  services.openssh = {
    enable = true;
    # Hardenings :)
    passwordAuthentication = false;
    permitRootLogin = "no";
    # Remove stale sockets automatically
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };

  services.openssh.hostKeys = [
    {
      bits = 4096;
      path = "/etc/ssh/ssh_host_rsa_key";
      type = "rsa";
    }
    {
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];

  environment.persistence."/persist".files = [
    "/etc/ssh/ssh_host_rsa_key"
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  # Passwordless sudo when SSHing with keys
  security.pam.enableSSHAgentAuth = true;
}
