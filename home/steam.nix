{ pkgs, inputs, ... }: 
let

  package = pkgs.steam;

  script = pkgs.writeShellScriptBin "steam" ''
    HOME=$HOME/.local/share/steamHome
    STEAM_EXTRA_COMPAT_TOOLS_PATHS=${pkgs.callPackage inputs.proton-ge {}}
    ${package}/bin/steam
  '';

in {

  home.packages = [ (pkgs.symlinkJoin {
    name = "steam-script-and-package";
    paths = [ script package ];
  }) ];

  persist.directories = [
    ".local/share/steamHome"
  ];

}
