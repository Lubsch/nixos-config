{ pkgs, inputs }:
(inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [ 
    ../home/nvim.nix
    ../home/common/misc.nix # Persist option has to exist, stateVersion must be set
    {
      # Required by home manager
      home = {
        username = "user";
        homeDirectory = "/home/user";
      };
    }
  ];
}).config.programs.neovim.finalPackage
