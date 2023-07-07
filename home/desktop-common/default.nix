{ pkgs, ... }: {
  imports = map (f: ./. + "/${f}")
    ((builtins.filter (f: f != "default.nix")) (builtins.attrNames (builtins.readDir ./.)));

  home = {
    packages = with pkgs; [
      wev # show pressed keys
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
}
