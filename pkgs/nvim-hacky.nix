{ pkgs, inputs }:
(inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [ 
    ../home/nvim.nix
    ../home/common/misc.nix # for 'persist'
    # required
    {
      home = {
        username = "user";
        homeDirectory = "/home/user";
      };
    }
  ];
}).config.programs.neovim.finalPackage
