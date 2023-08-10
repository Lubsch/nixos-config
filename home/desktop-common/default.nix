{ pkgs, ... }: {
  imports = with builtins; map (f: ./. + "/${f}")
    ((filter (f: f != "default.nix")) (attrNames (readDir ./.)));

  home = {
    packages = with pkgs; [
      evince # gnome pdf viewer
      wev # show pressed keys
      mpv # media player
      ffmpeg-full # media tools (full, because it contains ffplay)
      xdragon # Drag and drop from terminal
      brightnessctl # Change brightness
      wl-clipboard # Clipboard manager
      gnome.nautilus # File manager
      libnotify # Command notify-send
    ];
  };
}
