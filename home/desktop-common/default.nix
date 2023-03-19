{ lib, pkgs, ... }: {
  imports = builtins.filter (n: n != "default.nix") (lib.listFilesRecursive ./.);

  home = {
    packages = with pkgs; [
      swaybg
      xdragon # Drag and drop from terminal
      brightnessctl # Change brightness
    ];
  };

  xdg.mimeApps.enable = true;
}
