{ lib, pkgs, ... }: {

  programs.git = {
    enable = true;
    userName = "Lubsch";
    userEmail = "33580245+Lubsch@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  home.packages = [ (pkgs.writeShellScriptBin "setup-git" ''
    if [ ! -e ~/.ssh/id_github.pub ]; then
      echo Creating Github key.
      ssh-keygen -t ed25519 -f ~/.ssh/id_github
      cat ~/.ssh/id_github.pub | wl-copy
      $BROWSER https://github.com/settings/keys
      echo Press enter when done pasting keys.
      read
    fi
    if [ ! -e ~/.ssh/id_gitlab.pub ]; then
      echo Creating Gitlab key.
      ssh-keygen -t ed25519 -f ~/.ssh/id_gitlab
      cat ~/.ssh/id_gitlab.pub | wl-copy
      $BROWSER https://git.tu-berlin.de/-/profile/keys
      echo Press enter when done pasting keys.
      read
    fi
    mkdir -p ~/misc/repos
    if [ ! -e ~/misc/repos/nixos-config ]; then
      git clone git@github.com:Lubsch/nixos-config.git ~/misc/repos/nixos-config
    fi
  '') ];
}
