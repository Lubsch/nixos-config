# Global user config on all hosts
{ config, pkgs, username, ... }: {
  imports = [
    ./git.nix
    ./ssh.nix
    ./zsh.nix
    ./trash.nix
    ./zoxide.nix
    ./tealdeer.nix
    ./comma.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";

    packages = with pkgs; [
      ncdu # disk usage viewing
      tree # view file tree
      tree # view a nix derivation's dependencies
      tokei # count lines of code
      neofetch # system info
      ripgrep # better grep
      fd # better find
      magic-wormhole # send files between computers
    ];

    persistence."/persist${config.home.homeDirectory}" = {
      directories = [
        "documents"
        "downloads"
        "music"
        "pictures"
        "videos"
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
    # Where nvim things (and late some .nix-files) go
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  # Automatically reload systemd when changing hm configs
  systemd.user.startServices = "sd-switch";
}
