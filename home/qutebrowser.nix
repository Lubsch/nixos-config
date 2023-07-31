{ config, lib, pkgs, ... }: {
  home.sessionVariables.BROWSER = lib.mkForce "qutebrowser";

  programs.qutebrowser = {
    enable = true;
    package = pkgs.qutebrowser.override { enableWideVine = true; };

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

      config.unbind("J")
      config.unbind("K")
      config.bind("J", "tab-prev")
      config.bind("K", "tab-next")

      c.colors.webpage.preferred_color_scheme = "dark"

      c.fonts.default_family = "${config.fonts.regular.name}"
      c.fonts.default_size = "11pt"
      c.url.start_pages = "about:blank"
    '';
  };

  persist.directories = [ 
    ".local/share/qutebrowser"
  ];
}
