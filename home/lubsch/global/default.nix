# Default config of lubsch user on all hosts
{ inputs, lib, pkgs, config, outputs, ... }:
let
  inherit (inputs.nix-colors) colorSchems;
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
    username = lib.mkDefault "lubsch";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.05";

    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
        documents = "${config.home.homeDirectory}/documents";
        downloads = "${config.home.homeDirectory}/loads";
        music = "${config.home.homeDirectory}/music";
        pictures = "${config.home.homeDirectory}/pictures";
        videos = "${config.home.homeDirectory}/videos";
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
