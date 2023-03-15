{ config, ... }: {
  users.users.root.openssh.authorizedKeys = { inherit (config) keys; };
}
