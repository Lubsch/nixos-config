{ lib, config, ... }:
let 
  historyPath = "${config.xdg.dataHome}/zsh/history";
in {

  # Prevents collision with zsh history, hacky but works
  home.activation.delete-zsh-history = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -rf --interactive=never ${historyPath}
  '';

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      path = historyPath;
      size = 10000000;
    };
    autocd = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";

    shellAliases = {
      e = "$EDITOR";

      ns = "nix shell";
      nr = "nix run";
      nd = "nix develop";
      ne = "nix eval";
      nb = "nix build";

      iw = "iwctl station wlan0 scan; while ! iwctl station wlan0 get-networks | grep earl > /dev/null; do done; iwctl station wlan0 connect earl";

      myip = "curl ipinfo.io.me;echo";

      cp = "cp -ivr";
      mv = "mv -iv";
      rm = "rm -I";

      jctl = "journalctl -p 4 -xb";
    };

    # TODO improve git time
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
      prompt_char() {
        echo "$ "
      }
      prompt='%~ $(git_info)%f$(prompt_char)'

      # Disable C-s which freezes the terminal and is annoying
      stty stop undef

      # Remove delay when hitting esc, 1 because vi mode indicator update
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
          echo -ne "\e[6 q"
      }
      zle -N zle-line-init

      # Edit line in vim with ctrl-e:
      autoload edit-command-line; zle -N edit-command-line
      bindkey '^e' edit-command-line
    '';
  };

  persist.files = [ 
    (lib.removePrefix "${config.home.homeDirectory}/" historyPath)
  ];

}
