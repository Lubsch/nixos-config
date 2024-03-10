{ config, pkgs, inputs, ... }: {

  home.sessionVariables.BROWSER = config.programs.librewolf.package.meta.mainProgram;

  programs.librewolf = {
    enable = true;

    package = (pkgs.librewolf.override {
      extraPolicies = {
        ExtensionSettings = {
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            install_url = "file://${
              (pkgs.callPackage ../pkgs/vimium { inherit inputs; })
            }/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{d7742d87-e61d-4b78-b8a1-b469842139fa}.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    });

    settings = {
      "xpinstall.whitelist.required" = false;
      "xpinstall.signature.required" = false;
      # "singon.rememberSignons" = false;
      # "browser.shell.checkDefaultBrowser" = false;
      # "browser.shell.defaultBrowserCheckCount" = 1;
    };
  };

  # persist.directories = [ 
  #   ".librewolf" 
  # ];
}
