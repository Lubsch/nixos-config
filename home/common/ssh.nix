{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    controlMaster = "auto";
    controlPersist = "10m";
    controlPath = "/run/user/1000/master-%r@%n:%p";
    includes = [ "*_config" ];
  };

  persist.directories = [ 
    ".ssh"
  ];
}
