# TODO configure more here
{ pkgs, inputs, ... }:
let
  path-chooser = pkgs.writeShellScriptBin "path-chooser" ''
    choose() {
      echo Save "$bname":
      read -rep "" -i "$dir/" input

      if [ -d "$input" ]; then
        target="$input/$bname"
        return
      fi

      if [ -e "$target" ]; then
          echo "File already exists"
          echo
          choose
          return
      fi

      if [ -d "$(dirname "$target")" ]; then
          target="$input"
          return
      fi

      echo "Directory doesnt't exist"
      echo
      choose
    }

    bname=$(basename "$1")
    if [ -e /tmp/lastchoice.download-mover ]; then
      dir=$(cat /tmp/lastchoice.download-mover)
    else
      dir="$HOME"
    fi

    choose

    echo -n "$(dirname "$target")" > /tmp/lastchoice.download-mover
    echo -n "$target" > "$1".download-mover
  '';
in {

  home.sessionVariables.BROWSER = "firefox";

  systemd.user.services = {
    download-mover = {
      Unit.Description = "Better path chooser for firefox downloads";
      Install.WantedBy = [ "graphical-session.target" ];
      Service.ExecStart = "${pkgs.writeShellScriptBin "download-mover" ''
        ${inputs.download-mover.packages.${pkgs.system}.default}/bin/download-mover footclient --app-id=float ${path-chooser}/bin/path-chooser
      ''}/bin/download-mover";
    };
  };


  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        sponsorblock
        (pkgs.callPackage ../../pkgs/vimium { inherit inputs; })
      ];
    #   settings = {
    #     "identity.fxaccounts.enabled" = false;
    #     "privacy.trackingprotection.enabled" = true;
    #     "dom.security.https_only_mode" = true;
    #     "singon.rememberSignons" = false;
    #     "browser.shell.checkDefaultBrowser" = false;
    #     "browser.shell.defaultBrowserCheckCount" = 1;
    #   };
    };
  };

  # persist.directories = [ 
  #   ".mozilla" 
  # ];

}
