{ pkgs, ... }: 
let

  # script = pkgs.writeShellScriptBin "kp" ''
  #   if [ ! -e "$KEEPASS_DATABASE" ]; then
  #     notify-send "Keepass database not found" "$KEEPASS_DATABASE"
  #     $BROWSER localhost:8384
  #     exit
  #   fi
  #   timeout=30
  #   password=$(fuzzel -d --password)
  #   [ "$password" ] || exit
  #   list=$(echo "$password" | keepassxc-cli ls $KEEPASS_DATABASE -q)
  #   if [ ! "$list" ]; then
  #     notify-send "Password wrong"
  #     exit
  #   fi
  #   selection=$(echo "$list" | fuzzel -d)
  #   [ "$selection" ] || exit
  #     notify-send "Copied to clipboard" "Will be cleared in $timeout seconds"
  #   echo $password | keepassxc-cli clip -q $KEEPASS_DATABASE $selection $timeout
  #     exit
  # '';

in {
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
  home = {
    sessionVariables = {
      # PASSWORDMANAGER = script.name;
      KEEPASS_DATABASE = "$HOME/misc/keepass/secrets.kdbx";
    };

    packages = with pkgs; [ 
      keepassxc
      # script
    ];
  };
}
