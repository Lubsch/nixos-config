{ pkgs, ... }: {
  home = {
    sessionVariables.EDITOR = "nvim";
    packages = [ (import ./package.nix pkgs).nvim ];
  };

  # Persist log, shada, swap and undo (could require manual cleanup)
  persist.directories = [ 
    ".local/state/nvim" 
  ];
}
