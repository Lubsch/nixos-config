{ lib, inputs, impermanence, ... }: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    (lib.mkAliasOptionModule [ "persist" ] [ "environment" "persistence" "/persist" ])
  ];
  programs.fuse.userAllowOther = true;
  environment.persistence = lib.mkIf (!impermanence) (lib.mkForce { });
}
