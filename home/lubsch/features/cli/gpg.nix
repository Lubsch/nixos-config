{ pkgs
, config
, lib
, ...
}:
let
  fetchKey =
    { url
    , sha256 ? lib.fakeSha256
    ,
    }:
    builtins.fetchurl { inherit sha256 url; };

  pinentry =
    if config.gtk.enable
    then {
      package = pkgs.pinentry-gnome;
      name = "gnome3";
    }
    else {
      package = pkgs.pinentry-curses;
      name = "curses";
    };
in
{
  home.packages = [ pinentry.package ];

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = [ ];
    pinentryFlavor = pinentry.name;
    enableExtraSocket = true;
  };

  programs.zsh.profileExtra = "gpgconf --launch gpg-agent";

  environment.persistence."/persist".users.lubsch.directores = [ "${config.xdg.dataHome}/gnupg" ];

  programs.gpg = {
    enable = true;
    homeDir = "${config.xdg.dataHome}/gnupg";
    settings = {
      trust-model = "tofu-pgp";
    };
  };
}
