{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, cmake
, pixman
, wlroots_0_16
, wayland-protocols
, wayland
, libxkbcommon
, libinput
, xorg
, libdrm
, udev
, tomlc99
}:

stdenv.mkDerivation rec {
  pname = "vivarium";
  version = "unstable-2023-03-19";

  src = fetchFromGitHub {
    owner = "inclement";
    repo = "vivarium";
    rev = "93968853adcb145985c15e7a667bd989516b57a7";
    hash = "sha256-M7abEh5roE1+L3AfpYtTUidGLL2ME2ou62OWcxH5OWw=";
  };

  # remove test dependecies
  # and turn off Werror, since it current causes build to fail
  postPatch = ''
    sed -i \
      -e '/^fff_dep/d' \
      -e '/^unity_dep/d' \
      -e '/^subdir.*tests/d' \
      -e '/werror=true/d' \
      meson.build
    rm -rf tests
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    (tomlc99.overrideAttrs (old: {
      installPhase = ''
        make install prefix="$out"
        mkdir -p "$out/lib/pkgconfig"
        substituteInPlace libtoml.pc.sample \
          --replace '/usr/local' "$out" \
          --replace 'libtoml' 'toml'
        mv libtoml.pc.sample "$out/lib/pkgconfig/toml.pc"
      '';
    }))
  ];
  
  buildInputs = [
    wlroots_0_16
    wayland-protocols
    wayland
    libxkbcommon
    libinput
    xorg.xcbutilwm
    libdrm
    udev.dev
    pixman
  ];

  meta = with lib; {
    description = "A dynamic tiling Wayland compositor using wlroots";
    homepage = "https://github.com/inclement/vivarium/tree/support_wlroots_0.16";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
