{ config, lib, pkgs, ... }: {

  options = 
  let 
    mkDefault = value: lib.mkOption { default = value; };
  in {
    fonts = {
      regular = {
        name = mkDefault "Fira Sans";
        package = mkDefault pkgs.fira;
      };
      mono = {
        name = mkDefault "FiraCode Nerd Font"; 
        package = mkDefault 
          pkgs.nerdfonts.override { fonts = [ "FiraCode"]; }; 
      };
    };
  };

  config = {
    home.packages = with config.fonts; [ 
      regular.package 
      mono.package 
    ];

    # Program that auto-detects font on system
    fonts.fontconfig.enable = true;
  };
}

