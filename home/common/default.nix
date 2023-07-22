{ lib, pkgs, ... }: {
  imports = map (f: ./. + "/${f}")
    ((builtins.filter (f: f != "default.nix")) (builtins.attrNames (builtins.readDir ./.)));

  home = {
    stateVersion = "23.05";
    packages = with pkgs; [
      file # File information
      fq # Explore file formats
      imagemagick # Convert images
      entr # Run commands on file change (file watcher)
      inotify-tools # "
      poppler_utils # PDF utils (e.g. pdftotext)
      hyperfine # application benchmarks
      libqalculate # terminal calculator
      skim # fuzzy finder
      zip
      unzip
      nix-tree # view a nix derivation's dependencies
      ncdu # disk usage viewing
      tokei # count lines of code
      btop # resource usage viewer
      neofetch
      ripgrep # better grep
      fd # better find
      magic-wormhole # send files between computers
    ];
  };

  systemd.user.startServices = "sd-switch";
}
