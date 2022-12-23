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

  programs.zsh.loginExtra = "gpgconf --launch gpg-agent";

  home.persistence = { "persist/home/lubsch".directories = [ ".gnupg" ]; };

  programs.gpg = {
    enable = true;
    homeDir = "${config.xdg.dataHome}/gnupg";
    settings = {
      trust-model = "tofu-pgp";
    };
  };
}
