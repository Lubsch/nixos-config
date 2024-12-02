{ pkgs, config, ... }:
{
  home.packages = [ pkgs.way-displays ];

  xdg.configFile."way-displays/cfg.yaml".text = # yaml
  ''
    ARRANGE: COLUMN # on top of eachother
    ALIGN: MIDDLE
    ORDER:
      - DP
      - HDMI
      - eDP # embedded dp (laptop) bottom
    SCALING: TRUE
    AUTO_SCALE: TRUE
    AUTO_SCALE_MIN: 1
    AUTO_SCALE_MAX: -1
    SCALE:
      - NAME_DESC: LG Display 0x06ED (eDP-1)
        SCALE: 1.5
    VRR_OFF:
      - HDMI # no vrr on hdmi (I don't have HDMI 2.1)
  '';

  # TODO
  # hot reload
  # ponder about using shell variables instead
  wayland.windowManager.river = {
    enable = true;
    extraConfig = # sh
    ''
    # NOTE killing all processes with these names
    foot --server & # detects automatically if already running
    (old_pid=$(pidof way-displays) ; kill $old_pid ; ${pkgs.way-displays}/bin/way-displays) &
    (old_pid=$(pidof swaybg) ; ${pkgs.swaybg}/bin/swaybg -i ~/pictures/wallpapers/current & sleep 1 ; kill $old_pid) &
    (old_pid=$(pidof waybar) ; waybar & kill $old_pid) &

    riverctl map normal Super+Shift E exit

    riverctl input '*' poiner-accel 0
    riverctl input '*' accel-profile flat

    # Opening, closing
    riverctl map normal Super Return spawn ${config.home.sessionVariables.TERMINAL}
    riverctl map normal Super D close
    riverctl map normal Super V spawn ${config.home.sessionVariables.LAUNCHER}
    riverctl map normal Super W spawn ${config.home.sessionVariables.BROWSER}
    riverctl map normal Super R spawn 'echo re >> ${config.programs.zsh.history.path} ; ${config.home.sessionVariables.TERMINAL} zsh -ic "re; zsh -i"'

    # cursor and focus
    riverctl hide-cursor timeout 1000
    riverctl set-cursor-warp on-focus-change
    riverctl focus-follows-cursor always

    # Window switching
    riverctl map normal Super J focus-view next
    riverctl map normal Super K focus-view previous
    riverctl map normal Super+Shift J swap next
    riverctl map normal Super+Shift K swap previous

    # Monitor switching
    riverctl map normal Super Period focus-output next
    riverctl map normal Super Comma focus-output previous

    # Super+Shift+{Period,Comma} to send the focused view to the next/previous output
    riverctl map normal Super+Shift Period send-to-output next
    riverctl map normal Super+Shift Comma send-to-output previous

    # Super+Return to bump the focused view to the top of the layout stack
    riverctl map normal Super S zoom

    # Super+H and Super+L to decrease/increase the main ratio of rivertile(1)
    riverctl map -repeat normal Super H send-layout-cmd rivertile "main-ratio +0.015"
    riverctl map -repeat normal Super L send-layout-cmd rivertile "main-ratio -0.015"

    # Super+Shift+H and Super+Shift+L to increment/decrement the main count of rivertile(1)
    riverctl map normal Super+Shift H send-layout-cmd rivertile "main-count -1"
    riverctl map normal Super+Shift L send-layout-cmd rivertile "main-count +1"

    # Super+Alt+{H,J,K,L} to move views
    riverctl map -repeat normal Super+Alt H move left 50
    riverctl map -repeat normal Super+Alt J move down 50
    riverctl map -repeat normal Super+Alt K move up 50
    riverctl map -repeat normal Super+Alt L move right 50

    # Super+Alt+Control+{H,J,K,L} to snap views to screen edges
    riverctl map normal Super+Alt+Control H snap left
    riverctl map normal Super+Alt+Control J snap down
    riverctl map normal Super+Alt+Control K snap up
    riverctl map normal Super+Alt+Control L snap right

    # Super+Alt+Shift+{H,J,K,L} to resize views
    riverctl map -repeat normal Super+Alt+Shift H resize horizontal -50
    riverctl map -repeat normal Super+Alt+Shift J resize vertical 50
    riverctl map -repeat normal Super+Alt+Shift K resize vertical -50
    riverctl map -repeat normal Super+Alt+Shift L resize horizontal 50

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
    riverctl map normal Super 0 set-focused-tags $all_tags
    riverctl map normal Super+Shift 0 set-view-tags $all_tags

    riverctl map normal Super T toggle-float

    # Super+F to toggle fullscreen
    # TODO windowed fullscreen
    riverctl map normal Super F toggle-fullscreen

    # Super+{Up,Right,Down,Left} to change layout orientation
    riverctl map normal Super Up    send-layout-cmd rivertile "main-location top"
    riverctl map normal Super Right send-layout-cmd rivertile "main-location right"
    riverctl map normal Super Down  send-layout-cmd rivertile "main-location bottom"
    riverctl map normal Super Left  send-layout-cmd rivertile "main-location left"


    # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
    riverctl map -repeat normal None XF86AudioRaiseVolume  spawn '${pkgs.pamixer}/bin/pamixer -i 5'
    riverctl map -repeat normal None XF86AudioLowerVolume  spawn '${pkgs.pamixer}/bin/pamixer -d 5'
    riverctl map normal None XF86AudioMute         spawn '${pkgs.pamixer}/bin/pamixer --toggle-mute'

    # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
    riverctl map normal None XF86AudioMedia spawn '${pkgs.playerctl}/bin/playerctl play-pause'
    riverctl map normal None XF86AudioPlay  spawn '${pkgs.playerctl}/bin/playerctl play-pause'
    riverctl map normal Super Space    spawn '${pkgs.playerctl}/bin/playerctl play-pause'
    riverctl map normal None XF86AudioPrev  spawn '${pkgs.playerctl}/bin/playerctl previous'
    riverctl map normal None XF86AudioNext  spawn '${pkgs.playerctl}/bin/playerctl next'

    # Control screen backlight brightness with brightnessctl (https://github.com/Hummer12007/brightnessctl)
    riverctl map normal None XF86MonBrightnessUp   spawn '${pkgs.brightnessctl}/bin/brightnessctl set +5%'
    riverctl map normal None XF86MonBrightnessDown spawn '${pkgs.brightnessctl}/bin/brightnessctl set 5%-'

    # Set background and border color
    riverctl border-width 1
    riverctl border-color-focused 0x${config.colors.foreground}
    riverctl border-color-unfocused 0x101010

    # Set keyboard repeat rate and layout
    riverctl set-repeat 30 240
    riverctl keyboard-layout de

    # Make all views with an app-id that starts with "float" and title "foo" start floating.
    riverctl rule-add -app-id 'float*' float
    # server side decorations for firefox
    riverctl rule-add -app-id 'firefox' ssd

    # Make all views with app-id "bar" and any title use client-side decorations
    # riverctl rule-add -app-id "bar" csd

    # Set the default layout generator to be rivertile and start it.
    # River will send the process group of the init executable SIGTERM on exit.
    riverctl default-layout rivertile
    rivertile -main-location right -view-padding 0 -outer-padding 0 &

    pkill river-hot-reload
    ${pkgs.writeShellScript "river-hot-reload" ''
      ${pkgs.inotify-tools}/bin/inotifywait --event modify --event delete --event modify --event create .config/{river,waybar,way-displays}
      ${config.xdg.configHome}/river/init
    ''}/bin/river-hot-reload &
    '';
  };

  home.sessionVariables.WM = "${pkgs.writeShellScriptBin "wm" ''
    # to be used by greetd
    river > ${config.xdg.dataHome}/river.log 2>&1
  ''}/bin/wm";
}
