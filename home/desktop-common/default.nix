{ myLib, pkgs, ... }: {
  imports = myLib.getModules ./.;

  home = {
    packages = with pkgs; [
      mpv # media player
      ffmpeg-full # media tools (full, so there is ffplay)
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
