# Librewolf instead of firefox so I can install unsigned extensions
# not using hm-module so we can give it custom home location
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  BROWSER = "librewolf";
  BROWSERHOME = "${config.xdg.dataHome}/librewolfHome";

  vimium-overridden = (pkgs.callPackage ../pkgs/vimium { inherit inputs; }).override {
    settings = {
      smoothScroll = false;
      keyMappings = ''
        map s passNextKey
      '';
      searchUrl = "https://duckduckgo.com/?q=";
      exclusionRules = [ ];
      searchEngines = ''
        p: https://search.nixos.org/packages?query=%s
        o: https://search.nixos.org/options?query=%s
        h: https://home-manager-options.extranix.com/?query=%s
        n: https://noogle.dev/q?term=%s
      '';
    };
  };

  # install extensions using policies
  package = pkgs.librewolf.override {

    # about:config defaults
    extraPrefs = lib.concatStrings (
      lib.mapAttrsToList
        (name: value: ''
          defaultPref("${name}", ${builtins.toJSON value});
        '')
        {
          "intl.accept_languages" = "en-US, en, de";
          "browser.urlbar.resultMenu.keyboardAccessible" = false; # not 3 dots when tabbing through suggestions
          "general.useragent.override" = true;
          "xpinstall.whitelist.required" = false;
          "xpinstall.signatures.required" = false;
          "browser.download.dir" = config.xdg.userDirs.download; # else it'd be $BROWSERHOME/Downloads
          "browser.translation.automaticallyPopup" = false;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.tabs.delayHidingAudioPlayingIconMS" = 0; # no delay for "playing" in tabbar (eg. youtube)
          "full-screen-api.warning.timeout" = 0; # no fullscreen warning
          "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;
          "media.videocontrols.picture-in-picture.respect-disablePictureInPicture" = true;
          "privacy.resistFingerprinting" = false; # enables dark theme for example
          "privacy.clearOnShutdown.history" = false;
          "privacy.clearOnShutdown.cache" = false;
          "privacy.clearOnShutdown.cookies" = false;
        }
    );

    extraPolicies = {
      ExtensionSettings = builtins.listToAttrs (
        map
          (pkg: {
            # name is complicated because firefox applies updates when the name changes
            name = "${builtins.hashString "sha256" pkg.outPath}-${pkg.addonId}";
            value = {
              installation_mode = "force_installed";
              install_url = "file://${pkg}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${pkg.addonId}.xpi";
            };
          })
          (
            with inputs.firefox-addons.packages.${pkgs.system};
            [
              vimium-overridden
              keepassxc-browser
              sponsorblock
              ublock-origin
            ]
          )
      );
    };
  };
in
{

  home.sessionVariables = {
    inherit BROWSER BROWSERHOME;
  };

  home.packages = [
    # change home location
    (pkgs.symlinkJoin {
      name = "librewolf-wrapped";
      buildInputs = [ pkgs.makeBinaryWrapper ]; # faster than shell based wrapper (hello: 4.5ms vs 3ms)
      paths = [ package ];
      postBuild = ''
        wrapProgram $out/bin/librewolf --set HOME ${BROWSERHOME}
      '';
    })
  ];

  systemd.user.tmpfiles.rules = [
    # keepassxc expects firefox, so create symlink
    "d ${BROWSERHOME}/.librewolf/native-messaging-hosts 700"
    "L ${BROWSERHOME}/.mozilla - - - - ${BROWSERHOME}/.librewolf"
    # make dconf settings also apply to librewolf
    "L ${BROWSERHOME}/.config/dconf - - - - ${config.xdg.configHome}/dconf"
  ];

  persist.directories = [
    "${lib.removePrefix "${config.home.homeDirectory}/" BROWSERHOME}/.librewolf"
  ];
}
