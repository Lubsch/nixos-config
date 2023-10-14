{ pkgs, ... }: {
  # TODO use systemd-run command instead
  home.packages = [ pkgs.inotify-tools ];
  # Example usage: in a.txt cat a.txt
  programs.zsh.initExtra = ''
    function in() {
        while true; do
            echo --------
            inotifywait -qe modify "$1"; ''${*:2}
        done
    }
  '';
}
