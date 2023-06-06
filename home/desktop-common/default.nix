{ lib, pkgs, ... }: {
  imports = builtins.filter (n: n != ./default.nix)
    (lib.filesystem.listFilesRecursive ./.);

  home = {
    packages = with pkgs; [
      mpv # media player
      zathura # pdf viewer
      xdragon # Drag and drop from terminal
      brightnessctl # Change brightness
      wl-clipboard # Clipboard manager
      pcmanfm # File manager
      libnotify # Command notify-send
    ];
  };

  xdg.mimeApps.enable = true;
}
