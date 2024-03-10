{ config, pkgs, inputs, ... }: {

  home.sessionVariables.BROWSER = config.programs.firefox.package.meta.mainProgram;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          install_url = "file://${
            (pkgs.callPackage ../../pkgs/vimium { inherit inputs; })
          }/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{d7742d87-e61d-4b78-b8a1-b469842139fa}.xpi";
          installation_mode = "force_installed";
        };
      };
    };
    profiles.default = {
      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        sponsorblock
      ];
      settings = {
        xpinstall.whitelist.required = false;
        # "identity.fxaccounts.enabled" = false;
        # "privacy.trackingprotection.enabled" = true;
        # "dom.security.https_only_mode" = true;
        # "singon.rememberSignons" = false;
        # "browser.shell.checkDefaultBrowser" = false;
        # "browser.shell.defaultBrowserCheckCount" = 1;
      };
    };
  };

  # persist.directories = [ 
  #   ".mozilla" 
  # ];

}
