{ pkgs, inputs, ... }: {
  warnings = if pkgs.tlrc.version != "1.8.0"
    then [ "New tlrc-version! Go ahead and reenable persistent cache in home/common/tldr.nix" ] else [];
  home.packages = [ pkgs.tlrc ];
  # persist.directories = [ 
  #   ".cache/tlrc"
  # ];
}
