{ config ? {
  home.sessionVariables.TERMINAL = "footclient";
  home.sessionVariables.BROWSER = "firefox";
}, pkgs }:
(pkgs.dwl.overrideAttrs (old: {
  patches = [];
})).override {
  conf = with config.home.sessionVariables; ''
    #define TERMINAL "${TERMINAL}"
    #define BROWSER "${BROWSER}"
  '' + builtins.readFile ./config.h;
}
