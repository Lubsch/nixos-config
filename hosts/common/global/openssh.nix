{ outputs, lib, config, ... }:
let
  hosts = outputs.nixosConfigurations;
  hostname = config.networking.hostName;
  pubKey = host: ../../${host}/ssh_host_ed25519_key.pub;
in
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


  programs.ssh = {
    # Get known hosts from each hosts public key file
    knownHosts = builtins.mapAttrs (name: _: {
      publicKeyFile = pubKey name;
      extraHostNames = lib.optional (name == hostname) "localhost";
    }) hosts;
  };

  # Passwordless sudo when SSHing with keys
  security.pam.enableSSHAgentAuth = true;
}
