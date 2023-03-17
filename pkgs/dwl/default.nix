pkgs:
pkgs.dwl.overrideAttrs (old: {
  patches = [];
}).override {
  conf = builtins.readFile ./config.h;
}

