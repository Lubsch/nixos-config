# Global user config on all hosts
{ pkgs, username, inputs, nixosConfig, ... }: 
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
  ] ++ lib.optional 
    nixosConfig._module.specialArts.impermanence
    inputs.impermanence.nixosModules.home-manager.impermanence;

  home = {
    inherit username homeDirectory;

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
  stateVersion = "23.05";
}
