{ myLib, pkgs, ... }: {
  imports = myLib.getModules ./.;

  systemd.user.startServices = "sd-switch";

  home = {
    stateVersion = "23.05";

    packages = with pkgs; [
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
      htop # resource usage viewer
      neofetch
      ripgrep # better grep
      fd # better find
      magic-wormhole # send files between computers
    ];
  };
}
