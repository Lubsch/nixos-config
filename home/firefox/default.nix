# TODO configure more here
{ config, pkgs, inputs, ... }:
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
    package = pkgs.firefox-devedition;
    policies = {
      ExtensionSettings = {
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          install_url = "file://${
            (pkgs.callPackage ../../pkgs/vimium { inherit inputs; })
          }/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{d7742d87-e61d-4b78-b8a1-b469842139fa}.xpi";
          installation_mode = "force_installed";
        };
      };
    };
    profiles.${config.home.username} = {
      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        sponsorblock
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
