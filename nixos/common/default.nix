{
  imports =
    with builtins;
    map (n: ./. + "/${n}") (filter (n: n != "default.nix") (attrNames (builtins.readDir ./.)));
}
