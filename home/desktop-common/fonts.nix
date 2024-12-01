{
  config,
  lib,
  pkgs,
  ...
}:
{

  options.my-fonts = lib.mkOption {
    default = {
      regular = {
        name = "Roboto";
        package = pkgs.roboto;
      };
      mono = {
        name = "JetBrains Mono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
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
