{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      warn_timeout = "2m";
    };
  };

  persist.directories = [ 
    ".local/share/direnv"
  ];
}
