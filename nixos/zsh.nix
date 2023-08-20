{ config, ...}: {

  programs.zsh.enable = true;
  environment = {
    etc."zshenv".text = ''export ZDOTDIR="$HOME"/.config/zsh''; # Source zshenv without ~/.zshenv
    pathsToLink = [ "/share/zsh" ]; # Make zsh-completions work
  };

  home-manager.users = builtins.mapAttrs (_: _: {
    imports = [ { 
      home.file.".zshenv".enable = false;
    } ];
  }) config.my-users;

}
