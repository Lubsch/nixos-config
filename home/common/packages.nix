{ pkgs, ... }: {
  home.packages = with pkgs; [
    xdg-ninja # clear home dir
    shellcheck # check script posix compliance
    gource # visualize git histories
    file # file information
    fq # explore file formats
    imagemagick # convert images
    poppler_utils # pdf utils (e.g. pdftotext)
    hyperfine # simple benchmarks
    libqalculate # terminal calculator
    zip unzip
    nix-tree # view a nix derivation's dependencies
    deadnix # find dead code in nix projects
    ncdu # disk usage viewing
    tokei # count lines of code
    btop # resource usage viewer
    neofetch # quickly show system info
    ripgrep # better grep
    fd # better find
    magic-wormhole # send files between computers
  ];
}
