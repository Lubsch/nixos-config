# pager - alternative to less
{ pkgs, ... }:
{
  home.packages = [ pkgs.moar ];
  home.sessionVariables.PAGER = "moar";
}
