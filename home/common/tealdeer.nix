{ config, ... }: {
  programs.tealdeer = {
    enable = true;
    settings = {
      updates = {
        auto_update = true;
      };
    };
  };

  home.persistence."/persist${config.home.homeDirectory}".directories = [ 
    ".cache/tealdeer"
  ];
}
