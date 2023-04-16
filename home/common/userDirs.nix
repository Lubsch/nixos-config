{ username, ... }: 
let homeDirectory = "/home/${username}"; in {
  home = {
    inherit username homeDirectory;
    persistence."/persist${homeDirectory}" = {
      directories = [
        "documents"
        "downloads"
        "music"
        "pictures"
        "videos"
        "misc"
      ];
      allowOther = true; # Access to binds for root
    };
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "${homeDirectory}/documents";
      download = "${homeDirectory}/downloads";
      music = "${homeDirectory}/music";
      pictures = "${homeDirectory}/pictures";
      videos = "${homeDirectory}/videos";
      publicShare = null;
      templates = null;
      desktop = null;
    };
  };
}
