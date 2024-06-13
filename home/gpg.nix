{ pkgs, config, ... }: 
let
  pinentryPackage = pkgs.pinentry-gnome3;
in {

  # gcr is a gnome dependency
  home.packages = [ pinentryPackage pkgs.gcr ];

  # services.gpg-agent = {
  #   enable = true;
  #   enableSshSupport = true;
  #   inherit pinentryPackage;
  # };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
}
