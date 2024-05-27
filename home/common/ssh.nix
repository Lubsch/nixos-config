{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    controlMaster = "yes";
    controlPersist = "10m";
  };

  persist.directories = [ 
    ".ssh"
  ];
}
