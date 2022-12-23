{ pkgs, ... }: {
  home.packages = with pkgs; [ trash-cli ];
  programs.zsh.shellAliases = {
    rm = "trash";
  };
}
