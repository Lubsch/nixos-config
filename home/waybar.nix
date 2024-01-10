{
  programs.waybar = {
    enable = true;
  };
  xdg.configFile."waybar/config".text = /* json */  ''
    {
        // "layer": "top", // Waybar at top layer
        // "position": "bottom", // Waybar position (top|bottom|left|right)
        "height": 30, // Waybar height (to be removed for auto height)
        // "width": 1280, // Waybar width
        "spacing": 4, // Gaps between modules (4px)
        // Choose the order of the modules
        "modules-left": ["hyprland/workspaces", "hyprland/mode", "hyprland/scratchpad"],
        "modules-center": ["hyprland/window"],
        "modules-right": ["idle_inhibitor", "cpu", "memory", "temperature", "battery", "battery#bat2", "tray", "clock", ],
        // Modules configuration
        // "sway/workspaces": {
        //     "disable-scroll": true,
        //     "all-outputs": true,
        //     "warp-on-scroll": false,
        //     "format": "{name}: {icon}",
        //     "format-icons": {
        //         "1": "",
        //         "2": "",
        //         "3": "",
        //         "4": "",
        //         "5": "",
        //         "urgent": "",
        //         "focused": "",
        //         "default": ""
        //     }
        // },
        "idle_inhibitor": {
            "format": "{icon}",
            "format-icons": {
                "activated": "",
                "deactivated": ""
            }
        },
        "tray": {
            // "icon-size": 21,
            "spacing": 10
        },
        "clock": {
            "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
            "format-alt": "{:%Y-%m-%d}"
        },
        "cpu": {
            "format": "{usage}% ",
            "tooltip": false
        },
        "memory": {
            "format": "{}% "
        },
        "temperature": {
            // "thermal-zone": 2,
            // "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
            "critical-threshold": 80,
            // "format-critical": "{temperatureC}°C {icon}",
            "format": "{temperatureC}°C {icon}",
            "format-icons": ["", "", ""]
        },
        "battery": {
            "states": {
                // "good": 95,
                "warning": 30,
                "critical": 15
            },
            "format": "{capacity}% {icon}",
            "format-charging": "{capacity}% ",
            "format-plugged": "{capacity}% ",
            "format-alt": "{time} {icon}",
            // "format-good": "", // An empty format will hide the module
            // "format-full": "",
            "format-icons": ["", "", "", "", ""]
        },
        "battery#bat2": {
            "bat": "BAT2"
        },
    }
  '';
}
