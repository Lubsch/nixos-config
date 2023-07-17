{ config, pkgs, inputs, ... }: {
  home = {
    sessionVariables.EDITOR = "nvim";
    packages = [ (import ./package.nix { inherit pkgs; with-servers = true; }) ];
  };

  # Persist log, shada, swap and undo (could require manual cleanup)
  home.persistence."/persist${config.home.homeDirectory}".directories = [ 
    ".local/state/nvim" 
  ];
}
