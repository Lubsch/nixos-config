{ config, ... }:
{
  xdg.userDirs =
    let
      homeDir = config.home.homeDirectory;
    in
    {
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
    {
      directory = "documents";
      method = "symlink";
    }
    {
      directory = "music";
      method = "symlink";
    }
    {
      directory = "pictures";
      method = "symlink";
    }
    {
      directory = "videos";
      method = "symlink";
    }
    {
      directory = "misc";
      method = "symlink";
    }
  ];
}
