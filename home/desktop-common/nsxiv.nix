{ pkgs, config, ... }: {
  home = {
    packages = [
      pkgs.nsxiv
    ];

    persistence."/persist${config.home.homeDirectory}".directories = [ 
      ".cache/nsxiv"
    ];
  };
}
