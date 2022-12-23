{ nixpkgs } {
home.packages = [trash]
programs.zsh.shellAliases = {
rm = "trash";
};
}
