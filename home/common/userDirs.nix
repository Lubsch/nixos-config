{ config, ... }:
let homeDir = config.home.homeDirectory; in {
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = homeDir;
    download = "${homeDir}/misc/downloads";
    documents = "${homeDir}/documents";
    music = "${homeDir}/music";
    pictures = "${homeDir}/pictures";
    videos = "${homeDir}/videos";
    publicShare = null;
    templates = null;
  };

  persist.directories = [
    "documents"
    "music"
    "pictures"
    "videos"
    "misc"
  ];
}
