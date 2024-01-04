{ pkgs, ... }: {
  xdg.configFile."keepassxc/keepassxc.ini".text = ''
    [General]
    ConfigVersion=2
    MinimizeAfterUnlock=true
    OpenPreviousDatabasesOnStartup=false
    RememberLastDatabases=false
    RememberLastKeyFiles=false

    [Browser]
    CustomProxyLocation=
    Enabled=true

    [GUI]
    ApplicationTheme=dark
    HideUsernames=true

    [Security]
    ClearClipboardTimeout=30
    LockDatabaseIdle=true
    LockDatabaseIdleSeconds=30
  '';
  home.packages = with pkgs; [ 
    keepassxc
    (pkgs.writeShellScriptBin "kp" ''
      keepassxc $HOME/misc/keepass/secrets.kdbx
    '')
  ];
}
