{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      path = "${config.home.homeDirectory}/.local/share/zsh/zsh_history";
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
    initExtra = ''
      # Disable C-s which freezes the terminal and is annoying
      stty stop undef

      # Prompt (should be replaced by something faster)
      git_branch_test_color() {
        local branch=$(git symbolic-ref --short HEAD 2> /dev/null)
        if [ -n "$branch" ]; then
          if [ -n "$(git status --porcelain)" ]; then
            local gitstatuscolor='%F{yellow}'
          else
            local gitstatuscolor='%F{green}'
          fi
          echo "$gitstatuscolor $branch"
        else
          echo ""
        fi
      }
      setopt PROMPT_SUBST
      PS1='[%9c$(git_branch_test_color)%F{none}]$ '

      # Change cursor shape for different vi modes.
      function zle-keymap-select {
          case $KEYMAP in
              vicmd) echo -ne '\e[1 q';;      # block
              viins|main) echo -ne '\e[5 q';; # beam
          esac
      }
      zle -N zle-keymap-select
      zle-line-init() {
          zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
          echo -ne "\e[5 q"
      }
      zle -N zle-line-init

      zstyle ':completion:*' menu select
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
    '';

  };
  home.persistence."/persist${config.home.homeDirectory}".files = [ ".local/share/zsh/zsh_history" ];
}
