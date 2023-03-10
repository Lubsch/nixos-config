{ lib, config, pkgs, ... }: {
  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";
    autocd = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "viins";

    shellAliases = {
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
      export HISTFILE=$HOME/.local/share/zsh/history
      export HISTSIZE=10000000
      export HISTSAVE=10000000

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
              vicmd) echo -ne '\e[2 q';;      # non-blinking block
              viins|main) echo -ne '\e[6 q';; # non-blinking beam
          esac
      }
      zle -N zle-keymap-select
      zle-line-init() {
          zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
          echo -ne "\e[5 q"
      }
      zle -N zle-line-init

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
  
  # Create the symlink before home-manager tries to create the history file
  home.persistence."/persist${config.home.homeDirectory}".directories = [ ".local/share/zsh" ];
}
