{
  imports =
    with builtins;
    map (n: ./common + "/${n}") (
      filter (
        n:
        !(elem n [
          "drives.nix"
          "default.nix"
        ])
      ) (attrNames (builtins.readDir ./common))
    );
}
