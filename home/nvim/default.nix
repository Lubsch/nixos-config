{ pkgs, ... }: {
  home = {
    sessionVariables.EDITOR = "nvim";
    packages = [ (pkgs.callPackage ./package.nix { lsp = false; })];
  };

  # Persist log, shada, swap and undo (could require manual cleanup)
  persist.directories = [ 
    ".local/state/nvim" 
  ];
}
