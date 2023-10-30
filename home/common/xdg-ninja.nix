# Fix programs not respecting xdg dirs
{ config, pkgs, ...}: {
    home = {
      packages = [ pkgs.xdg-ninja ]; # helper program
      sessionVariables = with config.xdg; {
        CARGO_HOME = "${dataHome}/cargo";
        STACK_ROOT = "${dataHome}/stack";
        SQLITE_HISTORY = "${cacheHome}/sqlite_history";
        PYTHONSTARTUP = "${builtins.toFile "pythonrc" ''
          import os
          import atexit
          import readline

          history = '${cacheHome}/python_history'
          try:
            readline.read_history_file(history)
          except OSError:
            pass

          def write_history():
            try:
            readline.write_history_file(history)
            except OSError:
              pass

              atexit.register(write_history)
        ''}";
        NPM_CONFIG_USERCONFIG = "${builtins.toFile "npmrc" ''
          prefix=${dataHome}/npm
          cache=${cacheHome}/npm
          tmp=$XDG_RUNTIME_DIR/npm
          init-module=${configHome}/npm/config/npm-init.js
        ''}";
      };
    };
}
