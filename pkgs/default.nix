nixpkgs:
nixpkgs.lib.genAttrs 
  [ "x86_64-linux" "aarch64-linux" ]
  (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    neovimLubsch = import ./nvim pkgs;
    dwlLubsch = import ./dwl pkgs;
  })
