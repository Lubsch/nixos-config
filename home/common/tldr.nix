{ pkgs, ... }:
{
  home.packages = [ pkgs.tlrc ];
  persist.directories = [
    {
      directory = ".cache/tlrc";
      method = "symlink";
    }
  ];
}
