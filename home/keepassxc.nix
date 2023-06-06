{ pkgs, ...}: {
  home = {
    packages = with pkgs; [ 
      keepassxc
      (writeShellScriptBin "kp" ''
        database=~/misc/keepass/secrets.kdbx
        timeout=30

        password=$(fuzzel -d --password)
        if [ -z "$password" ]; then
            exit
        fi

        list=$(echo "$password" | keepassxc-cli ls $database -q)
        if [ -z "$list" ]; then
            exit
        fi

        selection=$(echo "$list" | fuzzel -d)
        if [ -z "$selection" ]; then
            exit
        fi

        echo $password | keepassxc-cli clip -q $database $selection $timeout
      '')
    ];

    sessionVariables."PASSWORDMANAGER" = "kp";
  };
}
