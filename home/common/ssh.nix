{ username, config, lib, ... }:
{
  programs.ssh.enable = true;

  home.persistence = {
    "/persist/home/${username}".directories = [ ".ssh" ];
  };
}
