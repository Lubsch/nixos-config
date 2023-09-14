{  lib, config, ...}: {

  programs.zsh.enable = lib.mkIf (config.home-manager.users != {}) true;
  environment = lib.mkIf (config.home-manager.users != {}) {
    etc."zshenv".text = ''export ZDOTDIR="$HOME"/.config/zsh''; # Source zshenv without ~/.zshenv
    pathsToLink = [ "/share/zsh" ]; # Make zsh-completions work
  };

  home-manager.sharedModules = [ { 
    home.file.".zshenv".enable = false;
  } ];

}
