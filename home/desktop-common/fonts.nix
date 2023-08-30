{ config, lib, pkgs, ... }: {

  options.my-fonts = lib.mkOption {
    default = {
      regular = {
        name = "Roboto";
        package = pkgs.roboto;
      };
      mono = {
        name = "JetBrains Mono Nerd Font"; 
        package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }); 
      };
    };
  };

  config = {
    home.packages = with config.my-fonts; [ 
      regular.package 
      mono.package 
    ];

    # Program that auto-detects fonts on system
    fonts.fontconfig.enable = true;
  };
}

