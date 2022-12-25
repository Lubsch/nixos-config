{ inputs, pkgs, config, ... }:
let
  # inherit (pkgs) wallpapers;
  inherit (inputs.nix-colors) colorSchemes;
in
{
  # features to use
  imports = [
    ./global.nix
  ];

  # wallpaper = wallpapers.aenami-serenity;
  # colorscheme = colorSchemes.gruvbox;
}
