{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      github = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_github";
      };
      gitlab = {
        hostname = "git.tu-berlin.de";
        identityFile = "~/.ssh/id_gitlab";
      };
    };
  };

  persist.directories = [ 
    ".ssh"
  ];
}
