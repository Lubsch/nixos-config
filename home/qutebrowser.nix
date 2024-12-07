{ config, pkgs, ... }:
let
  configFile =
    builtins.toFile "config.py" # python
      ''
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

        # Clear messages, fullscreen, selections, and search on <esc>
        config.bind("<esc>", "clear-messages ;; clear-keychain ;; fullscreen --leave ;; jseval -qf ${builtins.toFile "deselect.js" "document.activeElement.blur(); window.getSelection().removeAllRanges()"} ;; search")

        # fullscreen on youtube etc
        config.bind("<", "fake-key f")
        config.bind(",", "fake-key f")

        c.url.start_pages = "about:blank"

        c.colors.webpage.preferred_color_scheme = "dark"
        c.fonts.default_family = "${config.my-fonts.regular.name}"
        c.fonts.default_size = "12pt"
        c.tabs.padding = {"bottom": 6, "left": 4, "right": 4, "top": 6} # large enough to tap
        c.completion.show = "auto"

        c.downloads.location.directory = "${config.xdg.userDirs.download}"
        c.downloads.position = "bottom"
        c.downloads.remove_finished = 0
      '';

  package = pkgs.qutebrowser.override { enableWideVine = true; };

  # faster hot-start, keep ~ clean (don't put .pki in it)
  script = pkgs.writeShellScriptBin "qutebrowser" ''
    # initial idea: Florian Bruhin (The-Compiler)
    # author: Thore Bödecker (foxxx0)
    HOME=${config.xdg.dataHome}/qutebrowserHome
    _url="$1"
    _qb_version=${package.version}
    _proto_version=1
    _ipc_socket="$XDG_RUNTIME_DIR/qutebrowser/ipc-$(echo -n "$USER" | md5sum | cut -d' ' -f1)"
    printf '{"args": ["%s"], "target_arg": null, "version": "%s", "protocol_version": %d, "cwd": "%s"}\n' \
        "$_url" \
        "$_qb_version" \
        "$_proto_version" \
        "$PWD" | ${pkgs.socat}/bin/socat -lf /dev/null - UNIX-CONNECT:"$_ipc_socket" "$@" || ${package}/bin/qutebrowser -C ${configFile} "$@" &
  '';
in
{
  home.sessionVariables.BROWSER = script.name;

  home.packages = [
    (pkgs.symlinkJoin {
      name = "qutebrowser-script-and-package";
      paths = [
        script
        package
      ];
    })
  ];

  persist.directories = [
    {
      directory = ".local/share/qutebrowserHome";
      method = "symlink";
    }
  ];
}
