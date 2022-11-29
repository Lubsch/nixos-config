{ mkShell
, nix
, home-manager
, git
, gnupg
, ...
}:
mkShell {
  nativeBuildInputs = [
    nix
    home-manager
    git
    gnupg
  ];
}
