{ inputs, pkgs, config, ... }:
let
  inherit (pkgs) wallpapers;
  inherit (inputs.nix-colors) colorSchemes;
in
{
  imports = [
    ./global
  ];

  wallpaper = wallpapers.aenami-serenity;
  colorscheme = colorSchemes.gruvbox;
}
