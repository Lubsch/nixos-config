{ lib, config, ... }:
{

  home.sessionVariables.TERMINAL = "footclient";

  xdg.mimeApps = {
    associations.added = {
      "x-scheme-handler/terminal" = "org.codeberg.dnkl.footclient.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/terminal" = "org.codeberg.dnkl.footclient.desktop";
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "${config.my-fonts.mono.name}:size=10";
        dpi-aware = "yes";
        resize-delay-ms = "0";
        pad = "1x1";
      };
      key-bindings = {
        pipe-command-output = "[wl-copy] Control+o";
        scrollback-down-half-page = "Control+j";
        scrollback-up-half-page = "Control+k";
        spawn-terminal = "Control+n";
      };
      colors =
        {
          inherit (config.colors) background foreground alpha;
        }
        // builtins.listToAttrs (
          map (i: {
            name = if i < 8 then "regular${builtins.toString i}" else "bright${builtins.toString (i - 8)}";
            value = config.colors."base${if i < 10 then "0" else ""}${builtins.toString i}";
          }) (lib.range 0 15)
        );
    };
  };
}
