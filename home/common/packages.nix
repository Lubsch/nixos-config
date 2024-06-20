{ pkgs, ... }: {
  home.packages = with pkgs; [
    nixfmt-rfc-style
    prefetch-npm-deps # for updating proofbuddy
    wireguard-tools # wg-quick for vpns
    qemu # vm runner
    shellcheck # check script posix compliance
    file # file information
    fq # explore file formats
    jq # json pipes
    imagemagick # convert images
    poppler_utils # pdf utils (e.g. pdftotext)
    hyperfine # simple benchmarks
    libqalculate # terminal calculator
    zip unzip
    nix-tree # view a nix derivation's dependencies
    nix-init # automatically package repos
    deadnix # find dead code in nix projects
    ncdu # disk usage viewing
    tokei # count lines of code
    btop # resource usage viewer
    neofetch # quickly show system info
    ripgrep # better grep
    fd # better find
    magic-wormhole # send files between computers
    openconnect

    # PROGRAMMING LANGUAGES ETC.
    (python3.withPackages (ps: with ps; [ numpy ]))
    (sqlite.override { interactive = true; })
  ];
}
