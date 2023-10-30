{ pkgs, inputs, ... }: {

  home.sessionVariables.BROWSER = "firefox";

  programs.firefox = {
    enable = true;
    # profiles.default = {
    #   extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
    #     ublock-origin
    #     sponsorblock
    #     vimium-c
    #     newtab-adapter
    #   ];
    #   settings = {
    #     "identity.fxaccounts.enabled" = false;
    #     "privacy.trackingprotection.enabled" = true;
    #     "dom.security.https_only_mode" = true;
    #     "singon.rememberSignons" = false;
    #     "browser.shell.checkDefaultBrowser" = false;
    #     "browser.shell.defaultBrowserCheckCount" = 1;
    #   };
    # };
  };

  persist.directories = [ 
    ".mozilla" 
  ];

}
