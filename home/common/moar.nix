{ pkgs, ... }:
{
  home.packages = [ pkgs.moar ];
  environment.sessionVariables.PAGER = "moar";
}
