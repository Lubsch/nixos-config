{ pkgs, inputs, ... }: 
let
  package = pkgs.steam;
  script = pkgs.writeShellScriptBin "steam" ''
    HOME=$HOME/.local/share/steamHome
    export STEAM_EXTRA_COMPAT_TOOLS_PATHS=${inputs.nix-gaming.packages.${pkgs.system}.proton-ge}
    ${package}/bin/steam
  '';
in {
  home.packages = [ (pkgs.symlinkJoin {
    name = "steam-script-and-package";
    paths = [ script package ];
  }) ];

  persist.directories = [
    { directory = ".local/share/steamHome"; method = "symlink"; }
  ];
}
