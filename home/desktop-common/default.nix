{ myLib, pkgs, ... }: {
  imports = myLib.modulesInDir ./.;

  home = {
    packages = with pkgs; [
      swaybg
      xdragon # Drag and drop from terminal
      brightnessctl # Change brightness
    ];
  };

  xdg.mimeApps.enable = true;
}
