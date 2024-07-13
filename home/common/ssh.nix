{
  programs.ssh = {
    enable = true;

    # ssh control socket
    controlMaster = "auto";
    controlPersist = "10m";
    controlPath = "/run/user/1000/master-%r@%n:%p";

    # keep sessions alive
    serverAliveInterval = 60;

    # for additional configs for individual hosts
    includes = [ "*_config" ];

    # always use identityfile "~/.ssh/<hostname as called>"
    # unless overridden in individual host's config
    extraConfig = "IdentitiesOnly yes";
    matchBlocks."*".identityFile = "%d/.ssh/%n";
  };

  persist.directories = [ ".ssh" ];
}
