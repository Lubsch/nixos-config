{ inputs
, lib
, username
, persistence
, features
, ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) map pathExists filter;
in
{
  imports =
    [
      ./cli
      ./rice
    ]
    # Import features that have modules
    ++ filter pathExists (map (feature ./${feature}) features);

  programs.home-manager.enable = true;

  home = {
    inherit username;
    stateVersion = "22.05";
    homeDirectory = "/home/${username}";
    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
        documents = "$HOME/documents";
        downloads = "$HOME/loads";
        music = "$HOME/audio";
        pictures = "$HOME/pictures";
        videos = "$HOME/videos";
      };
      dataHome = "$HOME";
    };
  };

  environment.persistence."/persist" = mkIf persistence {
    users.lubsch = {
      directories = [
        "audio"
        "documents"
        "loads"
        "misc"
        "pictures"
        "videos"
      ];
    };
  };
}
