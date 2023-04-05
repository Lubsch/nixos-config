{
  programs.zsh.enable = true;
  environment = {
    etc."zshenv".text = ''export ZDOTDIR="$HOME"/.config/zsh''; # Source zshenv without ~/.zshenv
    pathsToLink = [ "/share/zsh" ]; # Make zsh-completions work
  };
}
