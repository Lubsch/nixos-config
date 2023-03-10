{ pkgs }: {
  wayland.windowManager.sway= {
    enable = true;
    config = {
      startup = [
        { command = "${pkgs.autotiling-rs}/bin/autotiling-rs"; }
      ];
      window.border = 1;
    };
  };
}
