{ lib, inputs, config, ... }: {

  options.impermanence = lib.mkEnableOption "impermanence";

  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence 
    (lib.mkAliasOptionModule [ "persist" ] [ "home" "persistence" "/persist${config.home.homeDirectory}" ])
    { 
      persist = lib.mkIf (!config.impermanence) {
        directories = lib.mkForce [];
        files = lib.mkForce [];
      };
    }
  ];

  config.persist.allowOther = true;

}
