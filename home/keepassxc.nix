{ lib, pkgs, ... }: 
let

  script = pkgs.writeShellScriptBin "kp" ''
    if [ ! -e "$KEEPASS_DATABASE" ]; then
      notify-send "Keepass database not found" "$KEEPASS_DATABASE"
      $BROWSER localhost:8384
      exit
    fi
    timeout=30
    password=$(fuzzel -d --password)
    [ "$password" ] || exit
    list=$(echo "$password" | keepassxc-cli ls $KEEPASS_DATABASE -q)
    [ "$list" ] || exit
    selection=$(echo "$list" | fuzzel -d)
    [ "$selection" ] || exit
    echo $password | keepassxc-cli clip -q $KEEPASS_DATABASE $selection $timeout
  '';

in {
  home = {
    sessionVariables = {
      PASSWORDMANAGER = script.name;
      KEEPASS_DATABASE = "$HOME/misc/keepass/secrets.kdbx";
    };

    packages = with pkgs; [ 
      keepassxc
      script
    ];
  };
}
