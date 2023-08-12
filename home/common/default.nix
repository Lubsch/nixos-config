{ pkgs, username, ... }: {
  imports = with builtins; map (f: ./. + "/${f}")
    ((filter (f: f != "default.nix")) (attrNames (readDir ./.)));

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
    packages = with pkgs; [
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
  };

  systemd.user.startServices = "sd-switch";
}
