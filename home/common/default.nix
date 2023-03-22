{ lib, pkgs, username, ... }: 
let homeDirectory = "/home/${username}"; in {
  imports = builtins.filter (n: n != ./default.nix)
    (lib.filesystem.listFilesRecursive ./.);

  home = {
    stateVersion = "23.05";
    inherit username homeDirectory;

    packages = with pkgs; [
      hyperfine # benchmark utility
      libqalculate # terminal calculator
      skim # fuzzy finder
      unzip
      tree
      nix-tree # view a nix derivation's dependencies
      ncdu # disk usage viewing
      tokei # count lines of code
      htop # resource usage viewer
      neofetch
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
      allowOther = true; # Access to binds for root
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
  };

  # Nicely start user services on rebuild
  systemd.user.startServices = "sd-switch";
}
