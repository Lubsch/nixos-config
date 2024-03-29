{ pkgs, ...}: {
  home.packages = [ pkgs.ironbar ];

  xdg.configFile."ironbar/config.toml".text = ''
    anchor_to_edges = true
    icon_theme = "Paper"
    position = "bottom"

    [[end]]
    music_dir = "/home/jake/Music"
    player_type = "mpd"
    type = "music"

    [end.truncate]
    max_length = 100
    mode = "end"

    [[end]]
    host = "chloe:6600"
    player_type = "mpd"
    truncate = "end"
    type = "music"

    [[end]]
    cmd = "/home/jake/bin/phone-battery"
    type = "script"

    [end.show_if]
    cmd = "/home/jake/bin/phone-connected"
    interval = 500

    [[end]]
    format = [
        " {cpu_percent}% | {temp_c:k10temp_Tccd1}°C",
        " {memory_used} / {memory_total} GB ({memory_percent}%)",
        "| {swap_used} / {swap_total} GB ({swap_percent}%)",
        "󰋊 {disk_used:/} / {disk_total:/} GB ({disk_percent:/}%)",
        "󰓢 {net_down:enp39s0} / {net_up:enp39s0} Mbps",
        "󰖡 {load_average:1} | {load_average:5} | {load_average:15}",
        "󰥔 {uptime}",
    ]
    type = "sys_info"

    [end.interval]
    cpu = 1
    disks = 300
    memory = 30
    networks = 3
    temps = 5

    [[end]]
    max_items = 3
    type = "clipboard"

    [end.truncate]
    length = 50
    mode = "end"

    [[end]]
    class = "power-menu"
    tooltip = "Up: {{30000:uptime -p | cut -d ' ' -f2-}}"
    type = "custom"

    [[end.bar]]
    label = ""
    name = "power-btn"
    on_click = "popup:toggle"
    type = "button"

    [[end.popup]]
    orientation = "vertical"
    type = "box"

    [[end.popup.widgets]]
    label = "Power menu"
    name = "header"
    type = "label"

    [[end.popup.widgets]]
    type = "box"

    [[end.popup.widgets.widgets]]
    class = "power-btn"
    label = "<span font-size='40pt'></span>"
    on_click = "!shutdown now"
    type = "button"

    [[end.popup.widgets.widgets]]
    class = "power-btn"
    label = "<span font-size='40pt'></span>"
    on_click = "!reboot"
    type = "button"

    [[end.popup.widgets]]
    label = "Uptime: {{30000:uptime -p | cut -d ' ' -f2-}}"
    name = "uptime"
    type = "label"

    [[end]]
    type = "clock"

    [[start]]
    all_monitors = false
    type = "workspaces"

    [start.name_map]
    1 = "󰙯"
    2 = "icon:firefox"
    3 = ""
    Code = ""
    Games = "icon:steam"

    [[start]]
    favorites = [
        "firefox",
        "discord",
        "steam",
    ]
    show_icons = true
    show_names = false
    type = "launcher"

    [[start]]
    label = "random num: {{500:echo FIXME}}"
    type = "label"
  '';
}
