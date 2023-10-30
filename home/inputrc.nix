{
  programs.readline.extraConfig = ''
    set editing-mode vi
    set -o vi
    set show-mode-in-prompt on

    # check if on virtual console
    $if term=linux
      set vi-ins-mode-string \1\e[?0c\2
      set vi-cmd-mode-string \1\e[?8c\2
    $else
      set vi-ins-mode-string \1\e[6 q\2
      set vi-cmd-mode-string \1\e[2 q\2
    $endif

    # Single tab completion
    set show-all-if-unmodified on

    # Color files by types
    # Note that this may cause completion text blink in some terminals (e.g. xterm).
    set colored-stats On
    # Append char to indicate type
    set visible-stats On
    # Mark symlinked directories
    set mark-symlinked-directories On
    # Color the common prefix
    set colored-completion-prefix On
    # Color the common prefix in menu-complete
    set menu-complete-display-prefix On

    # Disable echo ^C after pressing it
    set echo-control-characters off
  '';
}
