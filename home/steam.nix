{ lib, pkgs, config, ... }: 
let
  steamHome = "${config.xdg.dataHome}/steamHome";
in {

  # Set its own home dir and add proton-ge
  home.packages = [ 
    (pkgs.steam.override {
      extraEnv = {
        HOME = steamHome;
        XDG_DATA_DIR = steamHome + "/.local/share";
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = lib.makeSearchPathOutput "steamcompattool" "" [ pkgs.proton-ge-bin ];
      };
    })
  ];

  persist.directories = [ 
    { 
      directory = lib.removePrefix "${config.home.homeDirectory}/" steamHome;
      method = "symlink"; # steam requires symlink (doesn't like fuse)
    }
    {  # ugly but better than nothing
      directory = ".local/share/Paradox Interactive";
      method = "symlink"; # steam requires symlink (doesn't like fuse)
    }
    
  ];
}
