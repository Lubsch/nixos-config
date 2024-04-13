{ lib, pkgs, inputs, config, ... }: 
let
  steamHome = "${config.xdg.dataHome}/steamHome";
in {

  # Set its own home dir and add proton-ge
  home.packages = [ 
    (pkgs.steam.override {
      extraEnv = {
        HOME = steamHome;
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = pkgs.proton-ge;
      };
    })
  ];

  persist.directories = [ { 
    directory = lib.removePrefix "${config.home.homeDirectory}/" steamHome;
    method = "symlink"; # steam requires symlink (doesn't like fuse)
  } ];
}
