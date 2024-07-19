{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # TODO uncomment when not broken
    # visidata # data viewer in sheets
    prefetch-npm-deps # for updating npm projects
    wireguard-tools # wg-quick for vpns
    qemu # emualator
    shellcheck # check script posix compliance
    file # file information
    fq # explore file formats
    jq # json pipes
    imagemagick # convert images
    poppler_utils # pdf utils (e.g. pdftotext)
    hyperfine # simple benchmarks
    libqalculate # terminal calculator
    zip
    unzip
    nixfmt-rfc-style # nix formatter
    nix-tree # view a nix derivation's dependencies
    nix-init # automatically package repos
    deadnix # find dead code in nix projects
    ncdu
    dust # disk usage viewing
    tokei # count lines of code
    btop # resource usage viewer
    neofetch # quickly show system info
    ripgrep # better grep
    fd # better find
    magic-wormhole # send files between computers

    # PROGRAMMING LANGUAGES ETC.
    python3
    (sqlite.override { interactive = true; })
  ];
}
