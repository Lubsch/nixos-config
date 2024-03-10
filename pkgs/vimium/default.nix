{
  inputs,
  system,
  fetchurl,
  stdenv,
  unzip,
  web-ext,
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
        ${web-ext}/bin/web-ext build -n patched.xpi
        mkdir -p "$out"
        mv web-ext-artifacts/patched.xpi "$out"
      '';
    };
  in "${drv}/patched.xpi";
in
inputs.firefox-addons.packages.${system}.vimium.override { fetchurl = fetcher; }
