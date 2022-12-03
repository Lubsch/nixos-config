{ inputs, pkgs, config, ... }:
let
  inherit (pkgs) wallpapers;
  inherit (inputs.nix-colors) colorSchemes;
in
{
  imports = [ ./global
    ./features/cli
  ];

  wallpaper = wallpapers.aenami-serenity;
  colorscheme = colorSchemes.gruvbox;
}
