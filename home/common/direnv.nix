{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      warn_timeout = "0s";
    };
  };

  persist.directories = [ 
    ".local/share/direnv"
  ];
}
