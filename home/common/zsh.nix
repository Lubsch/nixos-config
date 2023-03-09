{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    # NOTE this is not set to xdg.configHome because dotDir takes a path relative to $HOME
    dotDir = ".config/zsh";
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      size = 100000000;
    };
    autocd = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "viins";
    shellAliases =
      {
        e = "$EDITOR";

        getip = "curl ifconfig.me";

        cp = "cp -iv";
        mv = "mv -iv";

        l = "${pkgs.exa}/bin/exa";
        ls = "${pkgs.exa}/bin/exa -la --group-directories-first --no-user --no-permissions --icons";
        la = "${pkgs.exa}/bin/exa -la --group-directories-first --icons";

        jctl = "journalctl -p 3 -xb";
      };
    initExtra = builtins.readfile ./zshrc;
  };
  home.persistence."/persist${config.xdg.dataHome}/zsh".files = [ "zsh_history" ];
}
