{ config, ... }: {
  programs.ssh.enable = true;

  home.persistence."/persist${config.home.homeDirectory}".directories = [ 
    ".ssh"
  ];
}
