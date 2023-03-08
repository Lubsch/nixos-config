# Global user config on all hosts
{ config, pkgs, username, ... }:
{
  imports = [
    ./git.nix
    ./ssh.nix
    ./zsh.nix
    ./trash.nix
    ./exa.nix
  ];

  # Automatically reload systemd when changing hm configs
  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/loads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      videos = "${config.home.homeDirectory}/videos";
      publicShare = null;
      templates = null;
      desktop = null;
    };
  };

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";

    packages = with pkgs; [
      comma # run programs without installing
      ncdu # disk usage viewing

      tealdeer # tldr pages
      neofetch # system info
      ripgrep # better grep
      fd # better find
    ];

    persistence."/persist${config.home.homeDirectory}" = {
      directories = [
        "documents"
        "loads"
        "pictures"
        "music"
        "videos"
        "misc"
      ];
      allowOther = true; # Allows other users (such as root when using doas) on the binds
    };
  };
}
