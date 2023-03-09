{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}";
    autocd = true;
    enableSyntaxHighlighting = true;
    shellAliases =
      {
        e = "$EDITOR";

        getip = "curl ifconfig.me";

        cp = "cp -iv";
        mv = "mv -iv";

        jctl = "journalctl -p 3 -xb";
      };
    defaultKeymap = "viins";
    initExtra = ''
        prompt off
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevl10k.zsh-theme
        # Archive extraction
        ex ()
        {
          if [ -f $1 ] ; then
            case $1 in
              *.tar.bz2)   tar xjf $1   ;;
              *.tar.gz)    tar xzf $1   ;;
              *.bz2)       bunzip2 $1   ;;
              *.rar)       unrar x $1   ;;
              *.gz)        gunzip $1    ;;
              *.tar)       tar xf $1    ;;
              *.tbz2)      tar xjf $1   ;;
              *.tgz)       tar xzf $1   ;;
              *.zip)       unzip $1     ;;
              *.Z)         uncompress $1;;
              *.7z)        7z x $1      ;;
              *.deb)       ar x $1      ;;
              *.tar.xz)    tar xf $1    ;;
              *.tar.zst)   unzstd $1    ;;
              *)           echo "'$1' cannot be extracted via ex()" ;;
            esac
          else
            echo "'$1' is not a valid file"
          fi
        }
        # Edit line in vim with ctrl-e:
        autoload edit-command-line; zle -N edit-command-line
        bindkey '^e' edit-command-line
      '';
  };
}
