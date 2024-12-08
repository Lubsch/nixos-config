# firefox dev so I can install unsigned extensions
# not using hm-module so we can give it custom home location
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  BROWSER = "firefox";
  BROWSERHOME = "${config.xdg.dataHome}/firefoxHome";

  # install extensions using policies
  package = pkgs.wrapFirefox pkgs.firefox-devedition-unwrapped {

    # pulls in large dependency (speechd)
    cfg.speechSynthesisSupport = false;

    # about:config defaults
    extraPrefs = lib.concatStrings (
      lib.mapAttrsToList
        (name: value: ''
          pref("${name}", ${builtins.toJSON value});
        '')
        {
          "browser.fullscreen.autohide" = false; # still show bar when going fullscreen
          "intl.accept_languages" = "en-US, en, de";
          "browser.aboutConfig.showWarning" = false;
          "extensions.activeThemeID" = "default-theme@mozilla.org"; # use gtk theme
          "browser.urlbar.resultMenu.keyboardAccessible" = false; # not 3 dots when tabbing through suggestions
          "xpinstall.whitelist.required" = false;
          "xpinstall.signatures.required" = false;
          "browser.download.dir" = config.xdg.userDirs.download; # else it'd be $BROWSERHOME/Downloads
          "browser.translation.automaticallyPopup" = false;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.tabs.delayHidingAudioPlayingIconMS" = 0; # no delay for "playing" in tabbar (eg. youtube)
          "full-screen-api.warning.timeout" = 0; # no fullscreen warning
          "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;
          "media.videocontrols.picture-in-picture.respect-disablePictureInPicture" = true;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.urlbar.suggest.addons" = false;
          "browser.urlbar.suggest.calculator" = false;
          "browser.urlbar.suggest.clipboard" = false;
          "browser.urlbar.suggest.engines" = false;
          "browser.urlbar.suggest.fakespot" = false;
          "browser.urlbar.suggest.mdn" = false;
          "browser.urlbar.suggest.pocket" = false;
          "browser.urlbar.suggest.quickactions" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.suggest.trending" = false;
          "browser.urlbar.suggest.weather" = false;
          "browser.urlbar.suggest.yelp" = false;
        }
    );

    extraPolicies = {
      SearchEngines = {
        Default = "DuckDuckGo";
        # To remove "This time search with..."
        Remove = [
          "Bing"
          "Google"
          "Wikipedia"
          "Bookmars"
          "Tabs"
          "History"
        ];
      };
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      PasswordManagerEnabled = false;
      Homepage.StartPage = "none";
      NewTabPage = false;
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
      ExtensionSettings = builtins.listToAttrs (
        map
          (pkg: {
            # name is complicated because firefox applies updates when the name changes
            name = pkg.addonId;
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

  vimium-overridden = (pkgs.callPackage ../pkgs/vimium { inherit inputs; }).override {
    settings = {
      smoothScroll = false;
      keyMappings = ''
        map w moveTabToNewWindow
        map s passNextKey
        unmap <<
        unmap >>
        map < moveTabLeft
        map > moveTabRight
      '';
      searchUrl = "https://duckduckgo.com/?q=";
      exclusionRules = [ "https?://typst.app/project/*" ];
      searchEngines = ''
        p: https://search.nixos.org/packages?query=%s
        o: https://search.nixos.org/options?query=%s
        h: https://home-manager-options.extranix.com/?query=%s
        n: https://noogle.dev/q?term=%s
      '';
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
      name = "firefox-wrapped";
      buildInputs = [ pkgs.makeBinaryWrapper ]; # faster than shell based wrapper (hello: 4.5ms vs 3ms)
      paths = [ package ];
      postBuild = ''
        wrapProgram $out/bin/firefox --set HOME ${BROWSERHOME}
      '';
    })
  ];

  systemd.user.tmpfiles.rules = [
    "d ${BROWSERHOME}/.mozilla/native-messaging-hosts 700"
    # make dconf settings also apply to firefox
    "L ${BROWSERHOME}/.config/dconf - - - - ${config.xdg.configHome}/dconf"
  ];

  persist.directories = [
    ".local/share/firefoxHome/.mozilla/firefox"
    ".local/share/firefoxHome/.mozilla/native-messaging-hosts"
  ];
}
