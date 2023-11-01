{ pkgs, ... }: {
  home.packages = with pkgs; [
    gource # visualize git histories
    pavucontrol # audio output manager
    evince # gnome pdf viewer
    wev # show pressed keys
    xorg.xeyes # find xwayland programs
    ffmpeg-full # media tools (full for ffplay)
    brightnessctl # change brightness
    wl-clipboard # make wl-copy work
    gnome.nautilus # file manager
    libnotify # command notify-send
  ];
}
