{ colorscheme, wallpaper }:
let
  "gruvbox" = [
    "#1c1c1c"
    "#cc241d"
    "#98971a"
    "#d79921"
    "#458588"
    "#b16286"
    "#689d6a"
    "#a89984"
    "#928374"
    "#fb4934"
    "#b8bb26"
    "#fabd2f"
    "#83a598"
    "#d3869b"
    "#8ec07c"
    "#ebdbb2"
  ];
in
{
  scheme = self.${colorscheme};
  xresources = {
    properties = {
      "*.alpha" = 0.8;
      "*.color0" = scheme [ 0 ];
      "*.color1" = scheme [ 1 ];
      "*.color2" = scheme [ 2 ];
      "*.color3" = scheme [ 3 ];
      "*.color4" = scheme [ 4 ];
      "*.color5" = scheme [ 5 ];
      "*.color6" = scheme [ 6 ];
      "*.color7" = scheme [ 7 ];
      "*.color8" = scheme [ 8 ];
      "*.color9" = scheme [ 9 ];
      "*.color10" = scheme [ 10 ];
      "*.color11" = scheme [ 11 ];
      "*.color12" = scheme [ 12 ];
      "*.color13" = scheme [ 13 ];
      "*.color14" = scheme [ 14 ];
      "*.color15" = scheme [ 15 ];
      "*.background" = scheme [ 0 ];
      "*.foreground" = scheme [ 15 ];
      "*.cursorColor" = scheme [ 15 ];
    };
  };

  wallpaper =
    if wallpaper != null
      then pkgs.wallpapers.${wallpaper}
}
