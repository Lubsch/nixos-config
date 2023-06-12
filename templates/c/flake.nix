{
  outputs = { nixpkgs, ...}: 
  let
    forAllSystems = nixpkgs.lib.genAttrs
      [ "x86_64-linux" "aarch64-linux" ];
  in {
    devShell = forAllSystems (s:
      let 
        pkgs = nixpkgs.legacyPackages.${s}; 
      in
      pkgs.mkShell {
        packages = with pkgs; [
          valgrind
          gdb
          clang
        ];
      }
    );
  };
}
