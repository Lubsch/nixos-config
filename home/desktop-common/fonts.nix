{ config, lib, pkgs, ... }: {

  options = let 
    mkDefault = value: (lib.mkOption { default = value; });
  in {
    fonts = {
      regular = {
        name = mkDefault "Roboto";
        package = mkDefault pkgs.roboto;
      };
      mono = {
        name = mkDefault "JetBrains Mono Nerd Font"; 
        package = mkDefault (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono"]; }); 
      };
    };
  };

  config = {
    home.packages = with config.fonts; [ 
      regular.package 
      mono.package 
    ];

    # Program that auto-detects fonts on system
    fonts.fontconfig.enable = true;
  };
}

