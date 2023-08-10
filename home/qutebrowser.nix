{ config, lib, pkgs, ... }: {
  home.sessionVariables.BROWSER = lib.mkForce "qute";

  home.packages = [ (pkgs.writeShellScriptBin "qute" ''
    # initial idea: Florian Bruhin (The-Compiler)
    # author: Thore Bödecker (foxxx0)
    _url="$1"
    _qb_version='2.5.4'
    _proto_version=1
    _ipc_socket="$XDG_RUNTIME_DIR/qutebrowser/ipc-$(echo -n "$USER" | md5sum | cut -d' ' -f1)"
    printf '{"args": ["%s"], "target_arg": null, "version": "%s", "protocol_version": %d, "cwd": "%s"}\n' \
           "$_url" \
           "$_qb_version" \
           "$_proto_version" \
           "$PWD" | ${pkgs.socat}/bin/socat -lf /dev/null - UNIX-CONNECT:"$_ipc_socket" || "${config.programs.qutebrowser.package}/bin/qutebrowser" "$@" &
  '') ];

  programs.qutebrowser = {
    enable = true;

    # results in light theme :/
    package = pkgs.qutebrowser-qt6.override { enableWideVine = true; };

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

      config.bind("<esc>", "clear-messages")

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
    ".cache/qutebrowser"
  ];
}
