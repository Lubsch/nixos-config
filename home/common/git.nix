{
  programs.git = {
    enable = true;
    userName = "Lubsch";
    userEmail = "33580245+Lubsch@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  setup-scripts.git = {
    deps = [ "keepassxc" ];
    script = ''
      mkdir -p ~/misc/repos
      echo Prepare to upload your ssh public keys
      echo They will be copied to your clipboard.
      echo If they do not exist, they are generated first.
      if [ ! -e ~/.ssh/id_ed25519.pub ]; then
        ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
      fi
      cat ~/.ssh/id_ed25519.pub | wl-copy
      $BROWSER https://git.tu-berlin.de/-/profile/keys
      $BROWSER https://github.com/settings/keys
      if [ ! -e ~/misc/repos/nixos-config ]; then
        echo Press Enter when done copying keys
        read
        git clone git@github.com:Lubsch/nixos-config.git ~/misc/repos/nixos-config
      fi
    '';
  };
}
