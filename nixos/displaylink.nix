{ config, ... }:
{
  boot.extraModulePackages = [ config.boot.kernelPackages.evdi ];
}
