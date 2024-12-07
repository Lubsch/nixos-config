{
  lib,
  pkgs,
  config,
  ...
}:
let
  steamHome = "${config.xdg.dataHome}/steamHome";
in
{

  # Set its own home dir and add proton-ge
  home.packages = [
    (pkgs.steam.override {
      extraEnv = {
        HOME = steamHome;
        XDG_DATA_DIR = steamHome + "/.local/share";
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = lib.makeSearchPathOutput "steamcompattool" "" [
          pkgs.proton-ge-bin
        ];
      };
    })
  ];

  persist.directories = [
    (lib.removePrefix "${config.home.homeDirectory}/" steamHome)
    ".local/share/Paradox Interactive"
  ];
}
