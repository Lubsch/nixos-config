{ config, pkgs, ... }:
let
  configFile = builtins.toFile "config.py" ''
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
    c.fonts.default_family = "${config.my-fonts.regular.name}"
    c.fonts.default_size = "12pt"
    c.tabs.favicons.scale = 1.0
    c.tabs.padding = {"bottom": 6, "left": 4, "right": 4, "top": 6}
    c.completion.show = "auto"

    c.downloads.position = "bottom"
    c.downloads.remove_finished = 0
    c.downloads.location.directory = "${config.xdg.userDirs.download}"
  '';

  package = pkgs.qutebrowser.override { enableWideVine = true; };

  # don't put .pki in ~, faster hot-start
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
in {
  home.sessionVariables.BROWSER = script.name;

  home.packages = [ (pkgs.symlinkJoin {
    name = "qutebrowser-script-and-package";
    paths = [ script package ];
  }) ];

  persist.directories = [ 
    ".local/share/qutebrowserHome"
  ];
}
