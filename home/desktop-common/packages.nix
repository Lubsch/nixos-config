{ pkgs, ... }: {
  home.packages = with pkgs; [
    loupe # gnome image viewer
    gimp
    gource # visualize git histories
    pavucontrol # audio output manager
    evince # gnome pdf viewer
    wev # show pressed keys
    xorg.xeyes # find xwayland programs
    ffmpeg-full # media tools (full for ffplay)
    brightnessctl # change brightness
    wl-clipboard # make wl-copy work
    pcmanfm # file manager
    libnotify # command notify-send
    wpa_supplicant_gui # wireless manager
  ];
}
