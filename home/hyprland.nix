# TODO fix application env vars
{ pkgs, lib, config, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;

    # binde for repeat
    extraConfig = with config; with pkgs; ''
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = ,preferred,auto,auto
      exec-once = waybar
      exec-once = ${swaybg}/bin/swaybg -i ~/pictures/wallpapers/current
      # firefox `browser.sessionrestore.resume_from_crash` to false
      exec-once = [workspace special:music silent] firefox --new-window https://music.apple.com/de/library/recently-added
      exec-once = ${home.sessionVariables.TERMINALSERVER}
      exec-once = [workspace special:keepass silent] kp
      exec-once = [workspace special:qalc silent] foot qalc

      # Some default env vars.
      env = XCURSOR_SIZE,24

      $mainMod = SUPER

      bind = $mainMod, return, exec, ${home.sessionVariables.TERMINAL}
      bind = $mainMod, V, exec, ${home.sessionVariables.LAUNCHER}
      bind = $mainMod, W, exec, ${home.sessionVariables.BROWSER}

      bind = $mainMod, R, exec, ${home.sessionVariables.TERMINAL} zsh -ic "re; zsh -i"

      bind = $mainMod, G, exec, steam

      bind = Meta Shift, Enter, exec, systemctl suspend

      bind = ,XF86MonBrightnessUp, exec, ${brightnessctl}/bin/brightnessctl set 5%+
      bind = ,XF86MonBrightnessDown, exec, ${brightnessctl}/bin/brightnessctl set 5%-

      binde = ,XF86AudioLowerVolume, exec, ${pamixer}/bin/pamixer -d 2
      binde = ,XF86AudioRaiseVolume, exec, ${pamixer}/bin/pamixer -i 2

      bind = ,Xf86AudioPlay, exec, ${playerctl}/bin/playerctl play-pause
      bind = $mainMod, Space, exec, ${playerctl}/bin/playerctl play-pause
      bind = ,Xf86AudioPrev, exec, ${playerctl}/bin/playerctl previous
      bind = ,Xf86AudioNext, exec, ${playerctl}/bin/playerctl next

      bind = $mainMod SHIFT, E, exit,
      bind = $mainMod, D, killactive,
      bind = $mainMod, T, togglefloating,
      bind = $mainMod, S, layoutmsg, swapwithmaster
      bind = $mainMod, F, fullscreen, 1
      bind = $mainMod SHIFT, F, fullscreen, 0

      # 59 mean comma (,), 60 means dot (.)
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
          col.active_border = rgb(${colors.foreground})
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
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
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

      windowrule = float, float

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    '';
  };

  home.sessionVariables.WM = "Hyprland &>> ~/.local/share/hypr.log";
  programs.zsh.loginExtra = ''
    [ "$(tty)" = "/dev/tty1" ] && exec ${config.home.sessionVariables.WM}
  '';
}
