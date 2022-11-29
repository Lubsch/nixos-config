{ pkgs }:
{
  homeManagerModules = import ./modules/home-manager;
}
  # Import custom packages to top-level
  // (import ./pkgs { inherit pkgs; })
