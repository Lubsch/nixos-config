# Global user config on all hosts
{ impermanence, pkgs, username, inputs, ... }: 
let homeDirectory = "/home/${username}"; in {
  imports = [
    ./git.nix
    ./ssh.nix
    ./zsh.nix
    ./trash.nix
    ./zoxide.nix
    ./tealdeer.nix
    ./comma.nix
    ./colors.nix
    # ./automount.nix
  ] ++ [ (if impermanence 
     then inputs.impermanence.nixosModules.home-manager.impermanence
     else ./no-impermanence.nix) ];

  home = {
    stateVersion = "23.05";
    inherit username homeDirectory;

    packages = with pkgs; [
      libqalculate # terminal calculator
      skim # fuzzy finder
      unzip
      tree
      nix-tree # view a nix derivation's dependencies
      ncdu # disk usage viewing
      tokei # count lines of code
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
