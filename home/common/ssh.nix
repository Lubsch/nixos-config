{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
    serverAliveInterval = 60; # keep sessions alive
    includes = [ "*_config" ];
    # Always use identityFiles
    extraConfig = "IdentitiesOnly yes";

    matchBlocks = {
      "*" = {
        identityFile = "%d/.ssh/%n";
      };
    };
  };

  # add missing "/" at end
  home.sessionVariables.XDG_RUNTIME_DIR = "/run/user/1000/";

  persist.directories = [ 
    ".ssh"
  ];
}
