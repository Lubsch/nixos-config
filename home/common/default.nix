# Global user config on all hosts
{ config, pkgs, username, ... }: {
  imports = [
    ./git.nix
    ./ssh.nix
    ./zsh.nix
    ./trash.nix
    ./exa.nix
  ];

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
      magic-wormhole # send files between computers
    ];

    keyboard = {
      layout = "de";
      options = "caps:escape";
    };

    persistence."/persist${config.home.homeDirectory}" = {
      directories = [
        "${config.xdg.userDirs.documents}"
        "${config.xdg.userDirs.download}"
        "${config.xdg.userDirs.music}"
        "${config.xdg.userDirs.pictures}"
        "${config.xdg.userDirs.videos}"
        "misc"
      ];
      allowOther = true; # Allows other users (mainly root when using doas) on the binds
    };
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      videos = "${config.home.homeDirectory}/videos";
      publicShare = null;
      templates = null;
      desktop = null;
    };
  };

  # Automatically reload systemd when changing hm configs
  systemd.user.startServices = "sd-switch";

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };
}
