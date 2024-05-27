{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    controlMaster = "yes";
  };

  persist.directories = [ 
    ".ssh"
  ];
}
