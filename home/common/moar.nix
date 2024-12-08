{ pkgs, ... }:
{
  home.packages = [ pkgs.moar ];
  home.sessionVariables.PAGER = "moar";
}
