{ pkgs, ... }: {

  programs.git = {
    enable = true;
    includes = [ 
      {
        condition = "gitdir:~/misc/repos/";
        path = "~/misc/repos/.gitconfig";
      }
      {
        condition = "gitdir:~/documents/uni/";
        path = "~/documents/uni/.gitconfig";
      }
      {
        condition = "gitdir:~/documents/arbeit/";
        path = "~/documents/arbeit/.gitconfig";
      }
    ];
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  home.packages = [ (pkgs.writeShellScriptBin "setup-git" ''
    if [ ! -e ~/.ssh/id_ed25519.pub ]; then
      echo Creating id key
      ssh-keygen -t ed25519
    fi
    wl-copy < ~/.ssh/id_ed25519.pub
    $BROWSER https://github.com/settings/keys
    $BROWSER https://git.tu-berlin.de/-/profile/keys
    echo Press enter when done pasting keys.
    read
    mkdir -p ~/misc/repos
    if [ ! -e ~/misc/repos/nixos-config ]; then
      git clone git@github.com:Lubsch/nixos-config.git ~/misc/repos/nixos-config
    else
      cd ~/misc/repos/nixos-config
      git remote set-url origin git@github.com:Lubsch/nixos-config.git
    fi
  '') ];
}
