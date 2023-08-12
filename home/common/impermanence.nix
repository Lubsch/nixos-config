{ lib, inputs, impermanence, config, ... }: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence 
    (lib.mkAliasOptionModule [ "persist" ] [ "home" "persistence" "/persist${config.home.homeDirectory}" ])
  ];
  persist.allowOther = true;
  home.persistence = lib.mkIf (!impermanence) (lib.mkForce { });
}
