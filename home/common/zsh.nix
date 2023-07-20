{ lib, pkgs, nixosConfig ? { }, ... }: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      path = "$HOME/.local/share/zsh/history";
      size = 10000000;
    };
    autocd = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";

    shellAliases = {
      e = "$EDITOR";

      rr = "doas nixos-rebuild switch --flake ~/misc/repos/nixos-config";
      rrz = "export HIST=; rm -r --interactive=never ~/.local/share/zsh; doas nixos-rebuild switch --flake ~/misc/repos/nixos-config"; # Fix zsh history collision

      iw = "iwctl station wlan0 scan && sleep 0.3 && iwctl station wlan0 connect earl";

      myip = "curl ifconfig.me;echo";

      cp = "cp -ivr";
      mv = "mv -iv";
      rm = "rm -I";

      jctl = "journalctl -p 4 -xb";
    };

    initExtra = ''
      git_info() {
        local ref=$(git symbolic-ref --short HEAD 2> /dev/null)
        if [ -n "$ref" ]; then
          if [ -n "$(git status --porcelain)" ]; then
            local gitstatuscolor='%F{yellow}'
          else
            local gitstatuscolor='%F{green}'
          fi
          echo "$gitstatuscolor$ref "
        else
          echo ""
        fi
      }
      setopt PROMPT_SUBST
      prompt='%~ $(git_info)%f$ '

      # Disable C-s which freezes the terminal and is annoying
      stty stop undef

      # Remove delay when hitting esc
      export KEYTIMEOUT=1

      # Make backspace work as expected
      bindkey "^?" backward-delete-char

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
          echo -ne "\e[6 q"
      }
      zle -N zle-line-init

      # Archive extraction
      ex () {
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

  # Declutter home when defining zshenv through nixos
  home.file.".zshenv".enable = lib.mkIf (nixosConfig.environment.etc ? "zshenv") false;

  persist.files = [ 
    ".local/share/zsh/history"
  ];
}
