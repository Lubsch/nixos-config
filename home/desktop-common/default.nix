{ lib, pkgs, ... }: {
  imports = builtins.filter (n: n != ./default.nix)
    (lib.filesystem.listFilesRecursive ./.);

  home = {
    packages = with pkgs; [
      xdragon # Drag and drop from terminal
      brightnessctl # Change brightness
      imv # Image viewer
      wl-clipboard # Clipboard manager
      xdg-utils # For xdg-open to work
      pcmanfm # File manager
      libnotify # Command notify-send
    ];
  };

  xdg.mimeApps.enable = true;
}
