{ pkgs, ... }:
{
  home.packages = [ pkgs.tlrc ];
  persist.directories = [
    ".cache/tlrc"
  ];
}
