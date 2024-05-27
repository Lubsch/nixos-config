{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    controlMaster = "auto";
    controlPersist = "10m";
    controlPath = "~/run/user/1000/master-%r@%n:%p";
  };

  persist.directories = [ 
    ".ssh"
  ];
}
