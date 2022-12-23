# Default config of lubsch user on all hosts
{ inputs, lib, pkgs, outputs, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
  username = "lubsch";
  homeDirectory = "/home/lubsch";
in
{
  # Default features for all a
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nix-colors.homeManagerModule
    ../features/cli
    ../features/nvim
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  # Define default colorscheme
  colorscheme = lib.mkDefault colorSchems.gruvbox;

  # Nicely reload system units when changing hm configs
  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  nix = {
    packages = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  home = {
    inherit username;
    inherit homeDirectory;
    stateVersion = lib.mkDefault "22.05";

    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
        documents = "${homedirectory}/documents";
        downloads = "${homedirectory}/loads";
        music = "${homedirectory}/music";
        pictures = "${homedirectory}/pictures";
        videos = "${homedirectory}/videos";
      };
    };

    persistence = {
      "/persist/home/lubsch" = {
        directories = [
          "documents"
          "loads"
          "pictures"
          "music"
          "videos"
          "misc"
        ];
        allowOther = true;
      };
    };
  };
}
