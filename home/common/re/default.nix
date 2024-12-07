{ pkgs, ... }:
{
  # re script which used to be a shell alias
  # - (Regenerates and garbage collects files in generated)
  # - Rebuilds nixos system
  # - Commits if successful (with empty message)

  home.packages = [
    pkgs.nixos-rebuild-ng
    (pkgs.runCommandNoCC "re" { } ''
      mkdir -p $out/bin
      cp ${./re-script.zig} re.zig
      export XDG_CACHE_HOME=$(mktemp -d)
      ${pkgs.zig}/bin/zig build-exe re.zig
      mv re $out/bin
    '')
    # (pkgs.writeScriptBin "re" # python
    #   ''
    #     #!${pkgs.python3}/bin/python
    #     ${builtins.readFile ./re-script.py}
    #   ''
    # )
  ];
}
