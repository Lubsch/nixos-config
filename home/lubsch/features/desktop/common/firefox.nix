{ pkgs, lib, ... }:
let
  addons = inputs.firefox-addons.packages.${pkgs.system};
in
{
  programs.firefox = {
    enable = true;
    extensions = with addons; [
      ublok-origin
      vimium
      sponsorblock
    ];
    profiles.lubsch = {
      settings = {
        "browser.startup.homepage" = "about:blank";
        "identity.fxaccounts.enabled" = false;
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
        "singon.rememberSignons" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":["ublock0_raymondhill_net-browser-action","sponsorblocker_ajay_app-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","save-to-pocket-button","downloads-button","fxa-toolbar-menu-button","wayback_machine_mozilla_org-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["developer-button","ublock0_raymondhill_net-browser-action","sponsorblocker_ajay_app-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list"],"currentVersion":17,"newElementCount":6}'';
      };
    };
    home.persistence = {
      "/persistence/home/lubsch".directories = [ ".mozilla/firefox" ];
    };
  };
}
