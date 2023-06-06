{ pkgs, config, ... }: {
  home.packages = with pkgs; [ fuzzel ];
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
   font = ${config.fonts.regular.name}:size=12
   icon-theme = ${config.gtk.iconTheme.name}
   layer = overlay
   
   [colors]
   background = ${config.colors.background}ff
   text = ${config.colors.foreground}ff
  '';
}
