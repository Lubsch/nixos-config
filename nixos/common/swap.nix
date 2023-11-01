{ lib, config, ... }: {
  options.swap.size = lib.mkOption {};

  config.swapDevices = [ {
    device = "/swap/swapfile";
    size = config.swap.size * 1024;
  } ];
}
