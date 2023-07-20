{ pkgs, ... }: {
  home.packages = [
    pkgs.nsxiv
  ];
  persist.directories = [ 
    ".cache/nsxiv"
  ];
}
