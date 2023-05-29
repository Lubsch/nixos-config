{ pkgs, lib, config, inputs, ... }: {
  imports = [ inputs.hyprland.homeManagerModules.default ];

  wayland.windowManager.hyprland = {
    enable = true;
    nvidiaPatches = true;

    extraConfig = with config; with pkgs; ''
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=,preferred,auto,auto

      # Execute your favorite apps at launch
      # exec-once = firefox
      exec-once = foot --server
      exec-once = ${swaybg}/bin/swaybg -i ~/pictures/wallpapers/bliss-600dpi.png

      # Some default env vars.
      env = XCURSOR_SIZE,24

      input {
          repeat_delay = 240
          repeat_rate = 30

          kb_layout = de
          kb_options = caps:escape,altwin:swap_lalt_lwin

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
        disable_hyprland_logo = true
        disable_splash_rendering = true
      }

      decoration {
          rounding = 0
          blur = false
          blur_size = 3
          blur_passes = 1
          blur_new_optimizations = true

          drop_shadow = false
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = false

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      master {
        no_gaps_when_only = true
        new_on_top = true
        orientation = right
      }

      gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = true
      }

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      $mainMod = SUPER

      bind = $mainMod, return, exec, ${home.sessionVariables.TERMINAL}
      bind = $mainMod, W, exec, ${home.sessionVariables.BROWSER}

      bind = ,XF86MonBrightnessUp, exec, ${brightnessctl}/bin/brightnessctl set 5%+
      bind = ,XF86MonBrightnessDown, exec, ${brightnessctl}/bin/brightnessctl set 5%-

      bind = ,XF86AudioLowerVolume, exec, ${pamixer}/bin/pamixer -d 2
      bind = ,XF86AudioRaiseVolume, exec, ${pamixer}/bin/pamixer -i 2

      bind = ,Xf86AudioPlay, exec, ${playerctl}/bin/playerctl play-pause
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

      # Show windows on all workspaces
      bind = $mainMod, 0, pin

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
      bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
      bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
      bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
      bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
      bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
      bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
      bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
      bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
    '';
  };

  programs.zsh.loginExtra = ''
    [ "$(tty)" = "/dev/tty1" ] && exec Hyprland
  '';
}
