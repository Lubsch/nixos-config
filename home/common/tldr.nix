{
  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
    updateOnActivation = false;
  };

  persist.directories = [ 
    ".cache/tealdeer"
  ];
}
