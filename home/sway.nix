{ pkgs, ... }: {
  wayland.windowManager.sway= {
    enable = true;
    config = {
      startup = [
        { command = "${pkgs.autotiling}/bin/autotiling"; }
      ];
      input = {
        "*" = {
          xkb_layout = "de";
          xkb_options = "caps:escape,altwin:swap_lalt_lwin";
          repeat_delay = "300";
          repeat_rate = "30";
          accel_profile = "flat";
          pointer_accel = "0";
        };
      };
      modifier = "Mod4";
    };
    extraConfig = ''
      default_border pixel 1
    '';
  };
  programs.zsh.loginExtra = ''
    # If running from tty1 start sway
    [ "$(tty)" = "/dev/tty1" ] && exec sway
  '';
}
