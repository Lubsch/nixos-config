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

      c.url.start_pages = "about:blank"

      c.colors.webpage.preferred_color_scheme = "dark"
      c.fonts.default_family = "${config.fonts.regular.name}"
      c.fonts.default_size = "12pt"
      c.tabs.favicons.scale = 1.0
      c.tabs.padding = {"bottom": 6, "left": 4, "right": 4, "top": 6}

      c.downloads.position = "bottom"
      c.downloads.remove_finished = 0
    '';
  };

  persist.directories = [ 
    ".local/share/qutebrowser"
  ];
}
