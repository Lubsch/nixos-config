{ lib, ... }:
{
  options = {
    filtered-common = lib.mkOption { type = lib.types.listOf lib.types.string; };
  };

  imports =
    with builtins;
    map (n: ./common + "/${n}") (
      filter (n: !(elem n (config.filetered-common ++ [ "default.nix" ]))) (
        attrNames (builtins.readDir ./common)
      )
    );
}
