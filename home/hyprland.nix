{ config, inputs, ... }: {
  imports = [ inputs.hyprland.homeManagerModules.default ];

  wayland.windowManager.hyprland = {
    enable = true;
    nvidiaPatches = true;

    extraConfig = ''
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=,preferred,auto,auto

      # Execute your favorite apps at launch
      # exec-once = firefox

      # Some default env vars.
      env = XCURSOR_SIZE,24

      input {
          repeat_delay = 200
          repeat_rate = 30

          kb_layout = de
          kb_options = caps:escape,altwin:swap_lalt_lwin

          follow_mouse = 1

          touchpad {
              disable_while_typing = false
          }

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
          accel_profile = flat
      }

      general {
          gaps_in = 0
          gaps_out = 0
          border_size = 1
          col.active_border = rgb(33ccff) rgb(00ff99) 45deg
          col.inactive_border = rgba(595959aa)

          layout = master
      }

      misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
      }

      decoration {
          rounding = 0
          blur = true
          blur_size = 3
          blur_passes = 1
          blur_new_optimizations = true

          drop_shadow = true
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

      dwindle {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # you probably want this
      }

      master {
        no_gaps_when_only = true
        new_on_top = true
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

      bind = $mainMod, return, exec, foot
      bind = $mainMod, W, exec, firefox
      bind = $mainMod, D, killactive,
      bind = $mainMod, T, togglefloating,
      bind = $mainMod, F, fullscreen, 1
      bind = $mainMod SHIFT, F, fullscreen, 0
      bind = $mainMod SHIFT, E, exit,

      bind = $mainMod, Space, layoutmsg, swapwithmaster
      bind = $mainMod, M, layoutmsg, addmaster
      bind = $mainMod SHIFT, M, layoutmsg, removemaster

      bind = $mainMod, J, layoutmsg, cyclenext
      bind = $mainMod, K, layoutmsg, cycleprev

      bind = $mainMod SHIFT, J, layoutmsg, orientationbottom
      bind = $mainMod SHIFT, K, layoutmsg, orientationtop
      bind = $mainMod SHIFT, H, layoutmsg, orientationleft
      bind = $mainMod SHIFT, L, layoutmsg, orientationright

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
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

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
