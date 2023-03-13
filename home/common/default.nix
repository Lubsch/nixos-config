# Global user config on all hosts
{ pkgs, username, ... }: 
let homeDirectory = "/home/$username"; in {
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
    inherit username homeDirectory;
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

    persistence."/persist${homeDirectory}" = {
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
      documents = "${homeDirectory}/documents";
      download = "${homeDirectory}/downloads";
      music = "${homeDirectory}/music";
      pictures = "${homeDirectory}/pictures";
      videos = "${homeDirectory}/videos";
      publicShare = null;
      templates = null;
      desktop = null;
    };
    # Where nvim things (and late some .nix-files) go
    stateHome = "${homeDirectory}/.local/state";
  };

  # Automatically reload systemd when changing hm configs
  systemd.user.startServices = "sd-switch";
}
