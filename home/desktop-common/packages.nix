{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprpicker # color picker
    hyprshot # screenshots
    loupe # gnome image viewer
    # gimp
    # libreoffice
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
    simple-scan # here so we dont have gnome deps if unnecessary
    # wpa_supplicant_gui # wireless manager
  ];
}
