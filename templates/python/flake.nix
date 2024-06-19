{
  outputs = { self, nixpkgs }:
  let
    mapSystems = f: builtins.mapAttrs f nixpkgs.legacyPackages;
  in {

    # see official nixpkgs documentation
    # https://ryantm.github.io/nixpkgs/languages-frameworks/python/#how-to-consume-python-modules-using-pip-in-a-virtual-environment-like-i-am-used-to-on-other-operating-systems
    devShells = mapSystems (_: pkgs: { 
      default = pkgs.mkShell {
        packages = with pkgs; [
          python3
          python3Packages.venvShellHook
        ];
        venvDir = "./.venv";
        postVenvCreation = ''
            unset SOURCE_DATE_EPOCH
            pip install -r requirements.txt
            pip install -e .
        '';
        postShellHook = ''
          unset SOURCE_DATE_EPOCH
        '';
      };
    });

  };
}
