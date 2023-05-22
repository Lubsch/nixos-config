{ pkgs, ...}: {
  home.packages = [ pkgs.keepassxc ];
  programs.zsh.shellAliases."kp" = "keepassxc-cli clip ~/misc/keepass/secrets.kdbx";
}
