{ pkgs, inputs, ... }: {
  home = {
    sessionVariables.EDITOR = "nvim";
    packages = [ (import ./package.nix { inherit pkgs; with-servers = true; }) ];
  };

  # Persist log, shada, swap and undo (could require manual cleanup)
  persist.directories = [ 
    ".local/state/nvim" 
  ];
}
