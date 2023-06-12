{ config, ... }: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      warn_timeout = "0s";
    };
  };

  home.persistence."/persist${config.home.homeDirectory}".directories = [ 
    ".local/share/direnv"
  ];
}
