{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    controlMaster = "auto";
    controlPersist = "10m";
  };

  persist.directories = [ 
    ".ssh"
  ];
}
