{ lib, pkgs, inputs, config, ... }: 
let
  steamHome = "${config.xdg.dataHome}/steamHome";
in {

  # Set its own home dir and add proton-ge
  home.packages = with pkgs; [ 
    (symlinkJoin {
      name = "steam-wrapped";
      buildInputs  = [ makeBinaryWrapper ]; # faster than shell based wrapper
      paths = [ steam ];
      postBuild = ''
        wrapProgram $out/bin/steam \
          --set HOME ${steamHome} \
          --set STEAM_EXTRA_COMPAT_TOOLS_PATHS ${inputs.nix-gaming.packages.${system}.proton-ge}
      '';
    })
  ];

  persist.directories = [ { 
    directory = lib.removePrefix "${config.home.homeDirectory}/" steamHome;
    method = "symlink"; # steam requires symlink (doesn't like fuse
  } ];
}
