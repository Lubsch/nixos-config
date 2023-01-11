# Global user config on all hosts
{ colorSchemes, lib, pkgs, username, ... }:
let
  inherit username;
  homeDirectory = "/home/${username}";
in
{
  imports = [
    ./git.nix
    ./ssh.nix
    ./zsh.nix
    ./trash.nix
    ./exa.nix
  ];

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

    packages = with pkgs; [
      comma # run programs without installing
      ncdu # disk usage viewing

      tealdeer # tldr pages
      neofetch # system info
      ripgrep # better grep
      fd # better find
    ];

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
}
