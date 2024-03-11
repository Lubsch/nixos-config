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

    # about:config preferences
    extraPrefs = lib.concatStrings (lib.mapAttrsToList (name: value: ''
        defaultPref("${name}", ${builtins.toJSON value});
    '') {
      "xpinstall.whitelist.required" = false;
      "xpinstall.signatures.required" = false;
      "browser.download.dir" = config.xdg.userDirs.download; # else it'd be $BROWSERHOME/Downloads
      "browser.toolbars.bookmarks.visibility" = "never";
      "privacy.resistFingerprinting" = false; # enables dark theme for example
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cache" = false;
      "hii" = false;
    });

  };

  # Set its own home dir
  wrapped = pkgs.symlinkJoin {
    name = "librewolf-wrapped";
    buildInputs  = [ pkgs.makeBinaryWrapper ]; # faster than shell based wrapper (hello: 4.5ms vs 3ms)
    paths = [ package ];
    postBuild = ''
      wrapProgram $out/bin/librewolf --set HOME ${BROWSERHOME}
    '';
  };

in {
  home.sessionVariables = { inherit BROWSER BROWSERHOME; };

  # not using the librewolf hm-module because it makes assumptions about location of home
  home = {
    packages = [ wrapped ];

    # file."${BROWSERHOME}/.librewolf/librewolf.overrides.cfg".text =
      
  };

  # keepassxc expects firefox
  home.activation.librewolf-keepassxc = ''
    mkdir -p ${BROWSERHOME}/.librewolf/native-messaging-hosts
    mkdir -p ${BROWSERHOME}/.mozilla
    ln -sf ${BROWSERHOME}/.librewolf/native-messaging-hosts ${BROWSERHOME}/.mozilla/native-messaging-hosts
  '';


  # persist.directories = [ 
  #   ".librewolf" 
  # ];
}
