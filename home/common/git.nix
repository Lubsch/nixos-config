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
    deps = [ "keepass" ];
    script = ''
      mkdir -p ~/misc/repos
      echo Prepare to upload your ssh public keys
      echo They will be copied to your clipboard.
      echo If they do not exist, they are generated first.
      # TODO
      $BROWSER
    '';
  };
}
