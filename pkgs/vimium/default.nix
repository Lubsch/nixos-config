{
  lib,
  inputs,
  system,
  fetchurl,
  stdenv,
  zip,
  unzip,
  writeTextFile,
  diffutils, # to check if updates are necessary
  settings ? {}
}:
let
  pkg = inputs.firefox-addons.packages.${system}.vimium;

  # Original default settings, but escaped characters removed that js can't handle
  defaultSettings = builtins.fromJSON (builtins.readFile ./default-settings.json);

  mergedSettings = defaultSettings // settings;

  fetcher = { url, sha256 }:
  let

    drv = stdenv.mkDerivation {
      name = "patched-xpi";
      src = fetchurl { inherit url sha256; };

      buildCommand = ''
        ${unzip}/bin/unzip "$src" -d dir
        cd dir
        rm lib/settings.js
        cp ${writeTextFile {
          name = "settings.js";
          text = ''
            const defaultOptions = JSON.parse(String.raw`
            ${builtins.toJSON mergedSettings}
            `);
            ${builtins.readFile ./settings.js}
          '';
        }} lib/settings.js
        mkdir -p "$out"
        ${zip}/bin/zip -r -FS "$out/patched.xpi" *
      '';
    };
  in "${drv}/patched.xpi";

in
pkg.override {
  fetchurl = fetcher;
  meta = { 
    inherit defaultSettings mergedSettings;
    broken = pkg.meta.name != "vimium-2.1.2"; # break on updates
  };
}
