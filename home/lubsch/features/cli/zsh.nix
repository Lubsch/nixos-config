{
  progams.zsh = {
    enable = true;
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
    initExtra =
      ''
        # Prompt
        PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "


        # Use vim keys in tab complete menu:
        bindkey -M menuselect 'h' vi-backward-char
        bindkey -M menuselect 'k' vi-up-line-or-history
        bindkey -M menuselect 'l' vi-forward-char
        bindkey -M menuselect 'j' vi-down-line-or-history
        bindkey -v '^?' backward-delete-char

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
      ''
      ++ mkIf builtins.elem "zoxide" home.packages ''
        # Initialize Zoxide
        eval "$(zoxide init zsh --cmd zx)"

        # j as alternative to cd and z (zoxide)
        function j() {
            if [[ "$argv[1]" == "-"* ]]; then
                zx "$@"
            else
                cd "$@" 2> /dev/null || zx "$@"
            fi
        }
      '';
  };
}
# vim: filetype=nix
