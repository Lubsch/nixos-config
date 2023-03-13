{ config, pkgs, ... }: {
  home = {
    packages = [ pkgs.comma ];

    # Where an index of binaries in nixpkgs is kept
    persistence."/persist${config.home.homeDirectory}".directories = [ 
      ".cache/nix-index" 
    ];
  };
}
