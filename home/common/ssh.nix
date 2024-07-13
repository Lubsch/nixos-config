{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
    serverAliveInterval = 60; # keep sessions alive
    includes = [ "*_config" ];
    extraConfig = "IdentitiesOnly yes";

    matchBlocks = {
      "*" = {
        identityFile = "%n";
      };
    };
  };

  # add missing "/" at end
  home.sessionVariables.XDG_RUNTIME_DIR = "/run/user/1000/";

  persist.directories = [ 
    ".ssh"
  ];
}
