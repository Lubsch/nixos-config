{ pkgs, config, ... }: {
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
    # same home as browser (librewolf/firefox) for interop
    (symlinkJoin {
      name = "keepassxc-wrapped";
      paths = [ keepassxc ];
      buildInputs = [ makeBinaryWrapper ];
      postBuild = ''
        wrapProgram $out/bin/keepassxc --set HOME ${config.home.sessionVariables.BROWSERHOME}
      '';
    })
    (writeShellScriptBin "kp" ''
      keepassxc $HOME/misc/keepass/secrets.kdbx
    '')
  ];
}
