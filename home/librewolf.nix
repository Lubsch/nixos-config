# Librewolf instead of firefox so I can install unsigned extensions
{ config, pkgs, inputs, lib, ... }:
let
  BROWSER = "librewolf";
  BROWSERHOME = "${config.xdg.dataHome}/${BROWSER}Home";

  # install extensions using policies
  package = pkgs.librewolf.override {
    extraPolicies = {
      ExtensionSettings = {
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          install_url = "file://${
            (pkgs.callPackage ../pkgs/vimium { inherit inputs; })
          }/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{d7742d87-e61d-4b78-b8a1-b469842139fa}.xpi";
          installation_mode = "force_installed";
        };
        "keepassxc-browser@keepassxc.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4246845/keepassxc_browser-latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  # Set its own isolated home
  wrapped = pkgs.symlinkJoin {
    name = "librewolf-wrapped";
    paths = [ package ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/librewolf \
        --set HOME ${BROWSERHOME}
    '';
  };

  # about:config preferences
  prefs = {
    "xpinstall.whitelist.required" = false;
    "xpinstall.signatures.required" = false;
    # "browser.toolbars.bookmarks.visibility" = "never";
    "privacy.resistFingerprinting" = false;
    # "singon.rememberSignons" = false;
    # "browser.shell.checkDefaultBrowser" = false;
    # "browser.shell.defaultBrowserCheckCount" = 1;
  };

in {
  home.sessionVariables = { inherit BROWSER BROWSERHOME; };

  # not using the hm-module because it makes assumptions about location of home
  home = {
    packages = [ wrapped ];

    file."${BROWSERHOME}/.librewolf/librewolf.overrides.cfg".text =
      lib.concatStrings (lib.mapAttrsToList (name: value: ''
        defaultPref("${name}", ${builtins.toJSON value});
      '') prefs);
  };

  # home.activation.librewolf-keepassxc = ''
  #   mkdir -p ~/.librewolf/native-messaging-hosts
  # '';


  # persist.directories = [ 
  #   ".librewolf" 
  # ];
}
