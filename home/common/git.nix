{ pkgs, ... }: {

  programs.git = {
    enable = true;
    userName = "Lubsch";
    userEmail = "33580245+Lubsch@users.noreply.github.com";
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
    cat ~/.ssh/id_ed25519.pub | wl-copy
    cat ~/.ssh/id_ed25519.pub
    $BROWSER https://github.com/settings/keys
    echo Press enter when done pasting keys.
    read
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
