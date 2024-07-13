{
  programs.ssh = {
    enable = true;

    controlMaster = "auto";
    controlPersist = "10m";
    controlPath = "/run/user/1000/master-%r@%n:%p";

    # keep sessions alive
    serverAliveInterval = 60;

    includes = [ "*_config" ];

    # Always use identityfile with name "<hostname which was used when calling ssh>"
    extraConfig = "IdentitiesOnly yes";
    matchBlocks."*".identityFile = "%d/.ssh/%n";
  };

  persist.directories = [ 
    ".ssh"
  ];
}
