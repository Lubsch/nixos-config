{ config, ... }:
let homeDir = config.home.homeDirectory; in {
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    documents = "${homeDir}/documents";
    download = homeDir;
    music = "${homeDir}/music";
    pictures = "${homeDir}/pictures";
    videos = "${homeDir}/videos";
    publicShare = null;
    templates = null;
    desktop = homeDir;
  };

  persist.directories = [
    "documents"
    "music"
    "pictures"
    "videos"
    "misc"
  ];
}
