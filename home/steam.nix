{ pkgs, inputs, config, ... }: {
  home = {
    activation.steam = "mkdir -p ${config.xdg.dataHome}/steam";
    packages = [ 
      (pkgs.writeShellScriptBin "steam" ''
        HOME=${config.xdg.dataHome}/steam \
        STEAM_EXTRA_COMPAT_TOOLS_PATHS=${pkgs.callPackage inputs.proton-ge {}} \
        ${pkgs.steam}/bin/steam
      '')
    ];
  };

  persist.directories = [
    ".local/share/steam"
  ];
}
