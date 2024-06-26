# TODO fix application env vars
{ pkgs, config, lib, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''
      monitor = ,preferred,auto,auto
      exec-once = ${pkgs.swaybg}/bin/swaybg -i ~/pictures/wallpapers/current
      exec-once = foot --server
      # firefox `browser.sessionrestore.resume_from_crash` to false
      exec-once = [workspace special:music silent] ${config.home.sessionVariables.BROWSER} --new-window https://music.apple.com/de/library/recently-added
      exec-once = [workspace special:keepass silent] kp
      exec-once = [workspace special:qalc silent] ${config.home.sessionVariables.TERMINAL} zsh -ic "qalc"

      # Some default env vars.
      env = XCURSOR_SIZE,24

      $mainMod = SUPER

      # binde for repeat
      bind = $mainMod, return, exec, ${config.home.sessionVariables.TERMINAL}
      bind = $mainMod, V, exec, ${config.home.sessionVariables.LAUNCHER}
      bind = $mainMod, W, exec, ${config.home.sessionVariables.BROWSER}

      bind = $mainMod, R, exec, ${config.home.sessionVariables.TERMINAL} zsh -ic "re; zsh -i"

      bind = $mainMod, I, exec, cd ~/documents/wiki; xdg-open $EDITOR ~/documents/wiki/Agenda.md

      bind = $mainMod, G, exec, steam

      bind = Meta Shift, Enter, exec, systemctl suspend

      bind = ,XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+
      bind = ,XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-

      binde = ,XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 2
      binde = ,XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 2

      bind = ,Xf86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause
      bind = $mainMod, Space, exec, ${pkgs.playerctl}/bin/playerctl play-pause
      bind = ,Xf86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous
      bind = ,Xf86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next

      bind = $mainMod SHIFT, E, exit,
      bind = $mainMod, D, killactive,
      bind = $mainMod, T, togglefloating,
      bind = $mainMod, S, layoutmsg, swapwithmaster
      bind = $mainMod, F, fullscreen, 1
      bind = $mainMod SHIFT, F, fullscreen, 0

      # 59 means comma (,), 60 means dot (.)
      bind = $mainMod, 59, layoutmsg, removemaster
      bind = $mainMod, 60, layoutmsg, addmaster

      bind = $mainMod, J, layoutmsg, cyclenext
      bind = $mainMod, K, layoutmsg, cycleprev
      binde= $mainMod, H, splitratio, +0.015
      binde= $mainMod, L, splitratio, -0.015

      bind = $mainMod SHIFT, J, layoutmsg, orientationbottom
      bind = $mainMod SHIFT, K, layoutmsg, orientationtop
      bind = $mainMod SHIFT, H, layoutmsg, orientationleft
      bind = $mainMod SHIFT, L, layoutmsg, orientationright

      # Pin floating window
      bind = $mainMod, 0, pin

      bind = $mainMod, P, togglespecialworkspace, keepass
      bind = $mainMod, C, togglespecialworkspace, qalc

      bind = $mainMod, A, togglespecialworkspace, music
      bind = $mainMod SHIFT, A, movetoworkspacesilent, special:music
      
      ${lib.concatLines (map (n:
        let s = builtins.toString n; in ''
        bind = $mainMod, ${s}, workspace, ${s}
        bind = $mainMod SHIFT, ${s}, movetoworkspacesilent, ${s}
      '') (lib.range 1 9))}

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
      input {
          repeat_delay = 240
          repeat_rate = 30

          kb_layout = de

          follow_mouse = 1

          touchpad {
              disable_while_typing = false
              natural_scroll = true
              scroll_factor = 0.25
          }

          sensitivity = 0
          accel_profile = flat
      }

      general {
          # change when it works again
          cursor_inactive_timeout = 1

          gaps_in = 0
          gaps_out = 0
          border_size = 1
          col.active_border = rgb(${config.colors.foreground})
          col.inactive_border = rgb(000000)

          layout = master
      }

      misc {
        vrr = 2
        disable_hyprland_logo = true
        disable_splash_rendering = true
      }

      decoration {
          rounding = 0
          dim_special = 0.0
          blur {
            enabled = true
            size = 3
          }
          drop_shadow = false
          # shadow_range = 4
          # shadow_render_power = 3
          # col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = false
      }

      master {
        no_gaps_when_only = true
        new_on_top = true
        orientation = right
      }

      gestures {
          workspace_swipe = true
      }

      # float windows with class float
      windowrule = float, float
    '';
  };

  home.sessionVariables.WM = "${pkgs.writeShellScriptBin "wm" '' # to be used by greetd
    Hyprland > ${config.xdg.dataHome}/hypr.log 2>&1
  ''}/bin/wm";
}
