{ inputs, ... }: {
  imports = [ inputs.nix-serve-ng.nixosModules.default ];
  services.nix-serve.enable = true;
}
