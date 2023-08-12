{
  outputs = { nixpkgs, ...}: {
    devShell = builtins.mapAttrs (system: pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          # add packages here
        ];
      };
    } );
  };
}
