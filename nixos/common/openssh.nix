{ lib, ... }: {

  # Global keys vars, consumed by users.nix and only-root.nix
  options.keys = lib.mkOption {
    default = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+woFGMkb7kaOxHCY8hr6/d0Q/HIHIS3so7BANQqUe6" # arch
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvuIIrh2iuj2hX0zIzqLUC/5SD/ZJ3GaLcI1AyHDQuM" # droid
    ]; 
  };

  config = {
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;

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
  };
}
