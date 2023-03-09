{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      path = "${config.xdg.home.homeDirectory}/.local/share/zsh/zsh_history";
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
    initExtra = builtins.readFile ./zshrc;
  };
  home.persistence."/persist${config.home.homeDirectory}".files = [ ".local/share/zsh/zsh_history" ];
}
