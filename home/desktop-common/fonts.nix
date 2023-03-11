{ fonts, ... }: {
  # Program that auto-detects font on system
  fonts.fontconfig.enable = true;

  home.packages = [ fonts.regular.package fonts.mono.package ];
}

