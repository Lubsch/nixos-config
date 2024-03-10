{
  inputs,
  system,
  fetchurl,
  stdenv,
  zip,
  unzip,
}:
let
  fetcher = { url, sha256 }:
  let
    drv = stdenv.mkDerivation {
      name = "patched-xpi";
      src = fetchurl { inherit url sha256; };

      buildCommand = ''
        ${unzip}/bin/unzip "$src" -d dir
        cd dir
        patch -p1 < ${./patch}
        mkdir -p "$out"
        ${zip}/bin/zip -0 -r "$out/patched.xpi" *
      '';
    };
  in "${drv}/patched.xpi";
in
inputs.firefox-addons.packages.${system}.vimium.override { fetchurl = fetcher; }
