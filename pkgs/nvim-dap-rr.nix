{ lib
, vimUtils
, fetchFromGitHub
}:

vimUtils.buildVimPlugin rec {
  pname = "nvim-dap-rr";
  version = "unstable-2023-09-10";

  src = fetchFromGitHub {
    owner = "jonboh";
    repo = "nvim-dap-rr";
    rev = "f1678d5524aac8321c538883e77daa17d6be44f5";
    hash = "sha256-T8WB7C5JbFbJaQWgrGgqpPHiQBMbGnSPJN/jebuV58M=";
  };

  meta = with lib; {
    description = "Dap configuration for the record and replay debugger. Supports Rust, C++ and C";
    homepage = "https://github.com/jonboh/nvim-dap-rr";
    # license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [ ];
    mainProgram = "nvim-dap-rr";
    platforms = platforms.all;
  };
}
