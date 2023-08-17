{ pkgs, inputs, userModules, ... }: {

  droid = true;

  user.shell = "${pkgs.zsh}/bin/zsh";

  home-manager = {
    extraSpecialArgs = { 
      inherit inputs;
      username = "nix-on-droid";
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    config.imports = userModules ++ [ {
      home.stateVersion = "23.05";
      nixpkgs = {
        config = {
          allowUnfree = true; 
          enableParallelBuilding = true;
        };
      };
    } ];
  };

}
