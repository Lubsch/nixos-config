# Librewolf instead of firefox so I can install unsigned extensions
# not using hm-module so we can give it custom home location
{ config, pkgs, inputs, lib, ... }:
let
  BROWSER = "librewolf";
  BROWSERHOME = "${config.xdg.dataHome}/${BROWSER}Home";

  # install extensions using policies
  package = pkgs.librewolf.override {
    extraPolicies = {

      ExtensionSettings = map (pkg: {
        install_url = "file://${pkg}/share/mozilla/extension/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${pkg.name}.xpi";
      }) (with inputs.firefox-addons.packages.${pkgs.system}; [
        (pkgs.callPackage ../pkgs/vimium { inherit inputs; })
        keepassxc-browser
        sponsorblock
        ublock-origin
      ]);

    };

    # about:config preferences
    extraPrefs = lib.concatStrings (lib.mapAttrsToList (name: value: ''
        defaultPref("${name}", ${builtins.toJSON value});
    '') {
      "xpinstall.whitelist.required" = false;
      "xpinstall.signatures.required" = false;
      "browser.download.dir" = config.xdg.userDirs.download; # else it'd be $BROWSERHOME/Downloads
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.tabs.delayHidingAudioPlayingIconMS" = 0; # no delay for "playing" in tab (eg. youtube)
      "full-screen-api.warning.timeout" = 0;
      "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;
      "media.videocontrols.picture-in-picture.respect-disablePictureInPicture" = true;
      "privacy.resistFingerprinting" = false; # enables dark theme for example
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cache" = false;
      "privacy.clearOnShutdown.cookies" = false;
    });

  };

in {

  home.sessionVariables = { inherit BROWSER BROWSERHOME; };

  home.packages = [ 
    # change home location
    (pkgs.symlinkJoin {
      name = "librewolf-wrapped";
      buildInputs  = [ pkgs.makeBinaryWrapper ]; # faster than shell based wrapper (hello: 4.5ms vs 3ms)
      paths = [ package ];
      postBuild = ''
        wrapProgram $out/bin/librewolf --set HOME ${BROWSERHOME}
      '';
    })
  ];

  # keepassxc expects firefox
  home.activation.librewolf-keepassxc = ''
    mkdir -p ${BROWSERHOME}/.librewolf/native-messaging-hosts
    mkdir -p ${BROWSERHOME}/.mozilla
    ln -sf ${BROWSERHOME}/.librewolf/native-messaging-hosts ${BROWSERHOME}/.mozilla/native-messaging-hosts
  '';


  persist.directories = [ 
    "${lib.removePrefix "${config.home.homeDirectory}/" BROWSERHOME}/.librewolf" 
    "${lib.removePrefix "${config.home.homeDirectory}/" BROWSERHOME}/.cache/librewolf" # can be deleted but why not
  ];

}
