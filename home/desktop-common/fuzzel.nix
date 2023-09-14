{ pkgs, config, ... }: {
  home = {
    packages = with pkgs; [ fuzzel ];
    sessionVariables.LAUNCHER = "fuzzel";
  };

  xdg.configFile."fuzzel/fuzzel.ini".text = with config; ''
   font = ${my-fonts.regular.name}:size=12
   icon-theme = ${gtk.iconTheme.name}
   layer = overlay
   [colors]
   background = ${colors.background}ff
   text = ${colors.foreground}ff
  '';
}
