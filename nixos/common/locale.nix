{ lib, ... }: {
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
      LC_DATE = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];
  };
  time.timeZone = lib.mkDefault "Europe/Berlin";
}
