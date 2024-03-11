{ pkgs, inputs, config, ... }: 
let
  steamHome = "${config.xdg.dataHome}/steamHome";
in {

  # Set its own home dir and add proton-ge
  home.packages = [ (pkgs.runCommand "steam-wrapped" {
    buildInputs  = [ pkgs.makeBinaryWrapper ]; # faster than shell based wrapper
  } ''
    makeBinaryWrapper ${pkgs.steam}/bin/steam $out/bin/steam \
      --set HOME ${steamHome} \
      --set STEAM_EXTRA_COMPAT_TOOLS_PATHS ${inputs.nix-gaming.packages.${pkgs.system}.proton-ge}
  ''
  ) ];

  persist.directories = [
    { directory = steamHome; method = "symlink"; }
  ];
}
