{ lib, ... }:
{
  programs.waybar = {
    enable = true;
    settings = lib.mkForce { };
    style = # css
      ''
        * {
            /* `otf-font-awesome` is required to be installed for icons */
            /* font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif; */
            font-size: 10pt;
        }

        window#waybar {
            background-color: rgba(16, 16, 16, 1);
            /* border-bottom: 3px solid rgba(100, 114, 125, 0.5); */
            color: #ebdbb2;
            transition-property: background-color;
            transition-duration: 0s;
        }

        button {
            /* Use box-shadow instead of border so the text isn't offset */
            /* box-shadow: inset 0 -3px transparent; */
            /* Avoid rounded borders under each button name */
            border: none;
            border-radius: 0;
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        button:hover {
            background: inherit;
            /* box-shadow: inset 0 -3px #ffffff; */
        }

        #workspaces button {
            /* margin: 10px; */
            padding: 0 5px;
            /* background-color: #ebdbb2; */
            color: inherit;
        }

        #workspaces button.visible.hosting-monitor {
            color: #101010;
            background-color: #665c54;
        }

        #workspaces button.active.hosting-monitor {
            color: #101010;
            background-color: #ebdbb2;
        }

        #workspaces button.hosting-monitor {
            background-color: inherit;
            color: inherit;
        }

        #workspaces button.empty {
            color: #101010;
            /* background-color: inherit; */
        }

        #workspaces button {
            color: #665c54;
        }

        /* #workspaces button.hosting-monitor { */
        /*     background-color: #ebdbb2; */
        /*     color: #161616; */
        /* } */

        /* #workspaces button.urgent { */
        /*     background-color: #eb4d4b; */
        /* } */

        /* #mode { */
        /*     background-color: #64727D; */
        /*     box-shadow: inset 0 -3px #ffffff; */
        /* } */

        #clock,
        #battery,
        #cpu,
        #memory,
        #disk,
        #temperature,
        #backlight,
        #network,
        #pulseaudio,
        #wireplumber,
        #custom-media,
        #tray,
        #mode,

        #window,
        #workspaces {
            margin: 0 4px;
        }

        /* If workspaces is the leftmost module, omit left margin */
        .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
        }

        /* If workspaces is the rightmost module, omit right margin */
        .modules-right > widget:last-child > #workspaces {
            margin-right: 0;
        }

        #clock {
            color: inherit;
            background-color: inherit;
        }

        #battery {
            color: inherit;
        }

        /* #battery.charging, #battery.plugged { */
        /*     color: #ffffff; */
        /*     background-color: #26A65B; */
        /* } */

        /* @keyframes blink { */
        /*     to { */
        /*         background-color: #ffffff; */
        /*         color: #000000; */
        /*     } */
        /* } */

        /* Using steps() instead of linear as a timing function to limit cpu usage */
        #battery.critical:not(.charging) {
            background-color: #f53c3c;
            color: #ffffff;
            color: #ebdbb2;
            /* animation-name: blink; */
            /* animation-duration: 0.5s; */
            /* animation-timing-function: steps(12); */
            /* animation-iteration-count: infinite; */
            /* animation-direction: alternate; */
        }
      '';
  };

  xdg.configFile."waybar/config".text = # jsonc
    ''
      // -*- mode: jsonc -*-
      {
          // "layer": "top", // Waybar at top layer
          // "position": "bottom", // Waybar position (top|bottom|left|right)
          // "spacing": 4, // Gaps between modules (4px)
          // Choose the order of the modules
          "modules-left": [
              "hyprland/workspaces"
              // "hyprland/mode",
              // "hyprland/scratchpad",
          ],
          // "modules-center": [
          //     "hyprland/window"
          //
          // ],
          "modules-right": [
              // "mpd",
              // "idle_inhibitor",
              // "pulseaudio",
              "network",
              // "power-profiles-daemon",
              // "cpu",
              // "memory",
              // "temperature",
              // "backlight",
              // "keyboard-state",
              // "sway/language",
              "battery",
              // "battery#bat2",
              "clock"
              // "tray",
              // "custom/power"
          ],
          // Modules configuration
          "hyprland/workspaces": {
              // "active-only": true,
              "disable-scroll": true,
              "all-outputs": true,
              "warp-on-scroll": false,
          },
          "clock": {
              // "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
              "format": "{:%Y-%m-%d  %H:%M}"
          },
          // "cpu": {
          //     "format": "{usage}% ",
          //     "tooltip": false
          // },
          // "memory": {
          //     "format": "{}% "
          // },
          // "temperature": {
          //     // "thermal-zone": 2,
          //     // "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
          //     "critical-threshold": 80,
          //     // "format-critical": "{temperatureC}°C {icon}",
          //     "format": "{temperatureC}°C {icon}",
          //     "format-icons": ["", "", ""]
          // },
          // "backlight": {
          //     // "device": "acpi_video1",
          //     "format": "{percent}% {icon}",
          //     "format-icons": ["", "", "", "", "", "", "", "", ""]
          // },
          "battery": {
              "states": {
                  "good": 50,
                  "warning": 30,
                  "critical": 15
              },
              "format": "{capacity}% ▼",
              "format-full": "{capacity}% {icon}━",
              "format-charging": "{capacity}% ▲",
              "format-plugged": "{capacity}% {icon}━",
              // "format-alt": "{time} {icon}",
              // "format-good": "", // An empty format will hide the module
              // "format-full": "",
              // "format-icons": ["", "", "", "", ""]
          },
          // "battery#bat2": {
          //     "bat": "BAT2"
          // },
          // "power-profiles-daemon": {
          //   "format": "{icon}",
          //   "tooltip-format": "Power profile: {profile}\nDriver: {driver}",
          //   "tooltip": true,
          //   "format-icons": {
          //     "default": "",
          //     "performance": "",
          //     "balanced": "",
          //     "power-saver": ""
          //   }
          // },
          // "network": {
          //     // "interface": "wlp2*", // (Optional) To force the use of this interface
          //     "format-wifi": "{essid} ({signalStrength}%) ",
          //     "format-ethernet": "{ipaddr}/{cidr} ",
          //     "tooltip-format": "{ifname} via {gwaddr} ",
          //     "format-linked": "{ifname} (No IP) ",
          //     "format-disconnected": "Disconnected ⚠",
          //     "format-alt": "{ifname}: {ipaddr}/{cidr}"
          // },
          // "pulseaudio": {
          //     // "scroll-step": 1, // %, can be a float
          //     "format": "{volume}% {icon} {format_source}",
          //     "format-bluetooth": "{volume}% {icon} {format_source}",
          //     "format-bluetooth-muted": " {icon} {format_source}",
          //     "format-muted": " {format_source}",
          //     "format-source": "{volume}% ",
          //     "format-source-muted": "",
          //     "format-icons": {
          //         "headphone": "",
          //         "hands-free": "",
          //         "headset": "",
          //         "phone": "",
          //         "portable": "",
          //         "car": "",
          //         "default": ["", "", ""]
          //     },
          //     "on-click": "pavucontrol"
          // },
          // "custom/media": {
          //     "format": "{icon} {}",
          //     "return-type": "json",
          //     "max-length": 40,
          //     "format-icons": {
          //         "spotify": "",
          //         "default": "🎜"
          //     },
          //     "escape": true,
          //     "exec": "$HOME/.config/waybar/mediaplayer.py 2> /dev/null" // Script in resources folder
          //     // "exec": "$HOME/.config/waybar/mediaplayer.py --player spotify 2> /dev/null" // Filter player based on name
          // },
        //   "custom/power": {
        //       "format" : "⏻ ",
          // "tooltip": false,
          // "menu": "on-click",
          // "menu-file": "$HOME/.config/waybar/power_menu.xml", // Menu file in resources folder
          // "menu-actions": {
          // 	"shutdown": "shutdown",
          // 	"reboot": "reboot",
          // 	"suspend": "systemctl suspend",
          // 	"hibernate": "systemctl hibernate"
          // }
        //   }
      }
    '';
}
