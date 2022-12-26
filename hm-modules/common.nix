# Global user config on all hosts
{ inputs, lib, pkgs, username, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
  inherit username;
  homeDirectory = "/home/${username}";
in
{
  config = {
    # Nicely reload system units when changing hm configs
    systemd.user.startServices = "sd-switch";

    programs = {
      home-manager.enable = true;
    };

    nix = {
      package = pkgs.nix;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
      };
    };

    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
        documents = "${homeDirectory}/documents";
        download = "${homeDirectory}/loads";
        music = "${homeDirectory}/music";
        pictures = "${homeDirectory}/pictures";
        videos = "${homeDirectory}/videos";
      };
    };

    home = {
      inherit username;
      inherit homeDirectory;
      stateVersion = lib.mkDefault "22.05";

      persistence."/persist/home/${username}" = {
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
