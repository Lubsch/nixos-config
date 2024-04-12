{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  persist.directories = [ 
    ".ssh"
  ];
}
