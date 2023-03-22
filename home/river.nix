{ pkgs, ... }: {
  home.packages = [ pkgs.river ];
  
  programs.zsh.loginExtra = ''
    [ "$(tty)" = "/dev/tty1" ] && river
  '';

  xdg.configFile."river/init" = {
    text = ''
      #!/bin/sh
      set -x

      riverctl keyboard-layout -options "caps:escape,altwin:swap_lalt_lwin" de
      riverctl input * accel-profile = flat
      riverctl input * pointer-acel = 0

      riverctl map normal Super W spawn firefox
      riverctl map normal Super Return spawn foot

      riverctl map normal Super D close

      riverctl map normal Super+Shift E exit

      riverctl map -repeat normal Super J focus-view next
      riverctl map -repeat normal Super K focus-view previous

      riverctl map -repeat normal Super+Shift J swap next
      riverctl map -repeat normal Super+Shift K swap previous

      # Super+Period and Super+Comma to focus the next/previous output
      riverctl map -repeat normal Super Period focus-output next
      riverctl map -repeat normal Super Comma focus-output previous

      # Super+Shift+{Period,Comma} to send the focused view to the next/previous output
      riverctl map -repeat normal Super+Shift Period send-to-output next
      riverctl map -repeat normal Super+Shift Comma send-to-output previous

      # Super+Space to bump the focused view to the top of the layout stack
      riverctl map normal Super Space zoom

      riverctl map -repeat normal Super H send-layout-cmd rivertile "main-ratio -0.05"
      riverctl map -repeat normal Super L send-layout-cmd rivertile "main-ratio +0.05"

      riverctl map -repeat normal Super+Shift H send-layout-cmd rivertile "main-count +1"
      riverctl map -repeat normal Super+Shift L send-layout-cmd rivertile "main-count -1"

      # Super+Alt+{H,J,K,L} to move views
      riverctl map -repeat normal Super+Alt H move left 100
      riverctl map -repeat normal Super+Alt J move down 100
      riverctl map -repeat normal Super+Alt K move up 100
      riverctl map -repeat normal Super+Alt L move right 100

      # Super+Alt+Control+{H,J,K,L} to snap views to screen edges
      riverctl map normal Super+Alt+Control H snap left
      riverctl map normal Super+Alt+Control J snap down
      riverctl map normal Super+Alt+Control K snap up
      riverctl map normal Super+Alt+Control L snap right

      # Super+Alt+Shift+{H,J,K,L} to resize views
      riverctl map -repeat normal Super+Alt+Shift H resize horizontal -100
      riverctl map -repeat normal Super+Alt+Shift J resize vertical 100
      riverctl map -repeat normal Super+Alt+Shift K resize vertical -100
      riverctl map -repeat normal Super+Alt+Shift L resize horizontal 100

      # Super + Left Mouse Button to move views
      riverctl map-pointer normal Super BTN_LEFT move-view

      # Super + Right Mouse Button to resize views
      riverctl map-pointer normal Super BTN_RIGHT resize-view

      # Super + Middle Mouse Button to toggle float
      riverctl map-pointer normal Super BTN_MIDDLE toggle-float

      for i in $(seq 1 9)
      do
          tags=$((1 << ($i - 1)))

          # Super+[1-9] to focus tag [0-8]
          riverctl map normal Super $i set-focused-tags $tags

          # Super+Shift+[1-9] to tag focused view with tag [0-8]
          riverctl map normal Super+Shift $i set-view-tags $tags

          # Super+Control+[1-9] to toggle focus of tag [0-8]
          riverctl map normal Super+Control $i toggle-focused-tags $tags

          # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
          riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
      done

      # Super+0 to focus all tags
      # Super+Shift+0 to tag focused view with all tags
      all_tags=$(((1 << 32) - 1))
      riverctl map normal Super 0 toggle-focused-tags $all_tags
      riverctl map normal Super+Shift 0 toggle-view-tags $all_tags

      riverctl map normal Super T toggle-float

      # Super+F to toggle fullscreen
      riverctl map normal Super F toggle-fullscreen

      # Super+{Up,Right,Down,Left} to change layout orientation
      riverctl map normal Super Up    send-layout-cmd rivertile "main-location top"
      riverctl map normal Super Right send-layout-cmd rivertile "main-location right"
      riverctl map normal Super Down  send-layout-cmd rivertile "main-location bottom"
      riverctl map normal Super Left  send-layout-cmd rivertile "main-location left"

      # Declare a passthrough mode. This mode has only a single mapping to return to
      # normal mode. This makes it useful for testing a nested wayland compositor
      riverctl declare-mode passthrough

      # Super+F11 to enter passthrough mode
      riverctl map normal Super F11 enter-mode passthrough

      # Super+F11 to return to normal mode
      riverctl map passthrough Super F11 enter-mode normal

      # Control screen backlight brightness with light (https://github.com/haikarainen/light)
      riverctl map normal None XF86MonBrightnessUp   spawn 'brightnessctl set 5%+'
      riverctl map normal None XF86MonBrightnessDown spawn 'brightnessctl set 5%-'

      # Set background and border color
      riverctl border-color-focused 0x93a1a1
      riverctl border-color-unfocused 0x586e75

      # Set keyboard repeat rate
      riverctl set-repeat 30 240

      # Set the default layout generator to be rivertile and start it.
      # River will send the process group of the init executable SIGTERM on exit.
      riverctl default-layout rivertile
    '';
    executable = true;
  };
}
