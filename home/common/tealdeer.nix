{
  programs.tealdeer = {
    enable = true;
    settings = {
      updates = {
        auto_update = true;
      };
    };
  };

  persist.directories = [ 
    ".cache/tealdeer"
  ];
}
