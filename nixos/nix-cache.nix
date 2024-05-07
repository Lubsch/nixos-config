{ inputs, ... }: {
  imports = [ inputs.nix-serve-ng.nixosModules.default ];
  nix.sshServe.enable = true;
  nix.sshServe.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILT2hUBw9sDjvv+hlFuKrvu5wh13VGXLOPOJDVZBMc+N lubsch@shah" ];
}
