{
  programs.ssh = {
    enable = true;
    # addKeysToAgent = "yes";
    controlMaster = "auto";
    controlPersist = "10m";
    controlPath = "/run/user/1000/master-%r@%n:%p";
    includes = [ "*_config" ];
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  persist.directories = [ 
    ".ssh"
  ];
}
