{pkgs, nixos-generate, system}: {
  install-iso = pkgs.callPackage ./install-iso { inherit nixos-generate; inherit (pkgs) system; };
}
