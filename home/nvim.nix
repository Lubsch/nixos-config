{ pkgs, ... }: {
  home = {
    sessionVariables.EDITOR = "nvim";
    packages = [ (pkgs.callPackage ../pkgs/nvim { lsp = true; })];
  };

  # Persist log, shada, swap and undo (could require manual cleanup)
  persist.directories = [ 
    ".local/state/nvim" 
  ];
}
