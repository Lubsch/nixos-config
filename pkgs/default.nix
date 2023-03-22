nixpkgs:
nixpkgs.lib.genAttrs 
  [ "x86_64-linux" "aarch64-linux" ]
  (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nvim = import ./nvim pkgs;
    dwl = import ./dwl { inherit pkgs; };
  })
