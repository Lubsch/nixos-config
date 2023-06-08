{ lib, pkgs, ... }: {
  home.sessionVariables.BROWSER = lib.mkForce "qutebrowser";

  programs.qutebrowser = {
    enable = true;
    extraConfig = ''
      config.unbind("<Ctrl-d>")
      config.unbind("<Ctrl-d>")
      config.unbind("d")
      config.unbind("u")
      config.bind("d", "scroll-page 0 0.5")
      config.bind("u", "scroll-page 0 -0.5")

      config.unbind("xo")
      config.unbind("xO")
      config.bind("x", "tab-close")
      config.bind("X", "undo")
    '';
  };
}
