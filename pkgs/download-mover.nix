{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "download-mover";
  version = "unstable-2023-11-07";

  src = fetchFromGitHub {
    owner = "Lubsch";
    repo = "download-mover";
    rev = "495a0c27399c2bea32ac3d7f9629c4d5d0bd463a";
    hash = "sha256-U1l/EIYxRRwXl99yZ34mmpl6jXSUkU0sgG8Lu0wGXtU=";
  };

  cargoHash = "sha256-Mb4f7HzRbCLG5TBknmYkKDNwunWZsWyJMqWFHHukx2k=";

  meta = with lib; {
    description = "Moves files downloaded by firefox to a path selected using a user-supplied script";
    homepage = "https://github.com/Lubsch/download-mover";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [ ];
    mainProgram = "download-mover";
  };
}
