{ pkgs, ...}: 
let
  database = "~/misc/keepass/secrets.kdbx";
in {
  home = {

    sessionVariables."PASSWORDMANAGER" = "kp";

    packages = with pkgs; [ 
      keepassxc
      (writeShellScriptBin "kp" ''
        timeout=30

        password=$(fuzzel -d --password)
        if [ -z "$password" ]; then 
          exit
        fi

        list=$(echo "$password" | keepassxc-cli ls ${database} -q)
        if [ -z "$list" ]; then
          exit
        fi

        selection=$(echo "$list" | fuzzel -d)
        if [ -z "$selection" ]; then
          exit
        fi

        echo $password | keepassxc-cli clip -q ${database} $selection $timeout
      '')
      (writeShellScriptBin "setup-keepass" ''
        # deps syncthing
        echo Do not forget to sync passwords to ${database}
        $BROWSER localhost:8384
      '')
    ];
  };
}
