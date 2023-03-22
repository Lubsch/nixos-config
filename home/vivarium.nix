{ config, pkgs, ... }: {
  home.packages = [ (pkgs.callPackage ../pkgs/vivarium.nix { }) ];

  # NOTE could probably be done using a toml parsing function
  xdg.configFile."vivarium/config.toml".text = ''
    [global-config]
    # Not Alt, so Alt can still be used by swapping it with super
    meta-key = "logo"

    focus-follows-mouse = true

    workspace-names = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

    # Autogenerate keybinds to switch to workspaces, specifically:
    # - Bind meta-$N to switch to workspace number N, for each number key $N,
    # - Bind meta-shift-$N to move the active window to workspace number N, for each number key $N
    # You can also/alternatively create these bindings via custom [[keybind]]s below.
    # Set this to false to disable automatic keybind generation and leave the keybinds all to you.
    bind-workspaces-to-numbers = true

    win-move-cursor-button = "left"
    win-resize-cursor-button = "right"

    border-width = 1
    gap-width = 0
    active-border-colour = [1.0, 0.0, 0.7, 1.0]  # rgba
    inactive-border-colour = [0.6, 0.6, 0.9, 1.0]  # rgba

    allow-fullscreen = true

    # Desktop background colour. Note this is overridden by the [background] if set.
    clear-colour = [0.73, 0.73, 0.73, 1.0]

    ### BACKGROUND ###
    # The background options are displayed using `swaybg`. Make sure you have this installed
    # if you want to use them.
    [background]
    colour = "#bbbbbb"
    image = "/path/to/your/background.png"
    mode = "fill"

    ### XKB-CONFIG ###
    # These all accept standard xkb syntax and options, e.g. as you would pass to `setxkbmap`
    # run from a shell.
    [xkb-config]
    layout = "de"
    options = "caps:escape,altwin:swap_lalt_lwin"

    ### BAR ###
    # Options for configuring a bar program. The desktop bar (if any) is often used to display
    # information such as current workspaces, system information, and open windows.
    [bar]
    command = "waybar"  # note this is a command to execute: this program must be installed to work
    update-signal-number = 1

    ### IPC ###
    # Inter-process communication settings.
    [ipc]
    # The filename to which Vivarium will write workspace state information whenever something changes.
    # Programs can watch this file to display the workspace status.
    # This is a hacky solution that will be deprecated at some point.
    # workspaces-filename = "/path/to/some/file.txt"

    ### LAYOUTS ###
    # Configure any number of layouts. Each workspace gets an independent copy of each layout.
    # The following options are available for each layout:
    # - name : The layout name to display in bar programs and logs, can be anything
    #          Defaults to matching the `layout` option.
    # - layout : The name of the Vivarium layout function to use.
    #            Run `vivarium -h` to get a list of available layout names.
    # - show-borders : If true, draw borders around windows. Defaults to true.
    # - ignore-excluded-regions : If true, tile windows across the full workspace regardless of
    #                             space reserved for bars, system tray etc.
    #
    # Run `vivarium --list-config-options` to get a list of available layouts.

    [[layout]]
    name = "Tall"
    layout = "split"

    [[layout]]
    name = "Fullscreen"
    layout = "fullscreen"
    show-borders = false

    [[layout]]
    name = "Fullscreen No Borders"
    layout = "fullscreen"
    ignore-excluded-regions = true
    show-borders = false

    ### KEYBINDS ###
    # Configure any number of keybinds. The following options are available for each one:
    # - modifiers : List of strings, not compulsory, defaults to ["meta"]
    # - keysym : Keysym to bind to. The keysym is the value of the key as interpreted by your keyboard layout.
    #            You may not bind to both keysym and keycode in the same binding.
    # - keycode : Keycode to bind to. The keycode is the numerical identifier of the hardware key.
    #             It always has the same value for a given physical key regardless of your keyboard layout.
    # - action : Any Vivarium action.
    #            Run `vivarium -h` to show documentation of all available actions, or see examples below.
    # - <action-arguments> : Arguments for the `action`, if applicable.
    #                        See action documentation for available arguments.
    #
    # To find the keysym or keycode of a given key, use tools like `wev` or `xev`.
    #
    # Run `vivarium --list-config-options` to get a list of available keybind actions

    [[keybind]]
    keysym = "E"
    action = "terminate"

    [[keybind]]
    keysym = "Return"
    action = "do_exec"
    executable = "foot"

    [[keybind]]
    keysym = "w"
    action = "do_exec"
    executable = "firefox"

    [[keybind]]
    keysym = "l"
    action = "increment_divide"
    increment = 0.05

    [[keybind]]
    keysym = "h"
    action = "increment_divide"
    increment = -0.05

    [[keybind]]
    keysym = "comma"
    action = "increment_counter"
    increment = 1

    [[keybind]]
    keysym = "period"
    action = "increment_counter"
    increment = -1

    [[keybind]]
    keysym = "j"
    action = "next_window"

    [[keybind]]
    keysym = "k"
    action = "prev_window"

    [[keybind]]
    keysym = "J"
    action = "shift_active_window_down"

    [[keybind]]
    keysym = "K"
    action = "shift_active_window_up"

    [[keybind]]
    keysym = "t"
    action = "tile_window"

    # [[keybind]]
    # keysym = "space"
    # action = "next_layout"

    [[keybind]]
    keysym = "d"
    action = "close_window"

    [[keybind]]
    keysym = "space"
    action = "make_window_main"

    [[keybind]]
    keysym = "R"
    action = "reload_config"

    # [[keybind]]
    # keysym = "o"
    # action = "do_exec"
    # executable = "bemenu-run"

    [[keybind]]
    modifiers = []
    keysym = "XF86AudioMute"
    action = "do_shell"
    command = "pactl set-sink-mute 0 toggle"

    [[keybind]]
    modifiers = []
    keysym = "XF86AudioLowerVolume"
    action = "do_shell"
    command = "amixer -q sset Master 3%-"

    [[keybind]]
    modifiers = []
    keysym = "XF86AudioRaiseVolume"
    action = "do_shell"
    command = "amixer -q sset Master 3%+"

    ### LIBINPUT CONFIG ###
    # Create any number of libinput configurations. The following options are available for each libinput config:
    # - device-name : A string to match libinput devices that should have your rules applied.
    # - scroll-method : One of "no-scroll", "2-finger", "edge" or "scroll-button".
    # - scroll-button : An integer representing the libinput button index to use for scrolling.
    #                   Has no effect unless scroll-method="scroll-button".
    # - middle-emulation : If true, emulate middle click events when clicking left and right simultaneously.
    #                      Defaults to false.
    # - left-handed : If true, switch left and right buttons. Defaults to false.
    # - natural-scroll : If true, switch the scrolling direction from default style (scroll down => go down)
    #                    to so-called "natural" style (scroll down => go up). Defaults to false.
    # - disable-while-typing : If true, disables the device while typing. Defaults to false.
    # - click-method : Method for determining which button is being clicked.
    #                  One of "none", "areas" or "fingers". Defaults to "none"
    # - tap-to-click : If true, enable tap to click on touchpads and similar devices. Defaults to true.
    # - tap-button-map : Map from number of fingers (1,2,3) to clicked button when using tap-to-click.
    #                    One of "left-right-middle" or "left-middle-right", other options not supported.

    [[libinput-config]]
    # Example libinput-config for a popular trackball:
    device-name = "Logitech USB Trackball"
    scroll-method = "scroll-button"
    scroll-button = 8
    middle-emulation = true
    left-handed = false
    natural-scroll = false
    disable-while-typing = false
    click-method = "none"
    tap-to-click = true
    tap-button-map = "left-right-middle"

    ### DEBUG ###
    # Vivarium debug options included for completion. You will want to leave these with their
    # default values under normal operation.
    [debug]
    # Draw a graphical indicator of what shell (XDG, XWayland, Layer) is providing each window surface.
    mark-views-by-shell = false

    # Draw a graphical indicator of what shell (i.e. normally what monitor) is currently active.
    mark-active-output = false

    # Damage tracking: "none" to draw every frame, "frame" to draw only damaged frames, "full"
    # to draw only damaged regions of damaged frames
    damage-tracking-mode = "full"

    # Draw the background red before drawing damaged regions, so only damaged regions are rendered
    mark-undamaged-regions = false

    # Draw a small square that cycles through red/green/blue each time a frame is drawn
    mark-frame-draws = false
  '';

  programs.zsh.loginExtra = ''
    [ "$(tty)" = "/dev/tty1" ] && vivarium
  '';
}
