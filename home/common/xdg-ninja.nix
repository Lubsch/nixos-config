# Fix programs not respecting xdg dirs
{ config, pkgs, ... }:
{
  home = {
    packages = [ pkgs.xdg-ninja ]; # helper program
    sessionVariables = with config.xdg; {
      HISFILE = ""; # dont do bash history
      GNUPGHOME = "${dataHome}/gnupg";
      CARGO_HOME = "${dataHome}/cargo";
      STACK_ROOT = "${dataHome}/stack";
      SQLITE_HISTORY = "${cacheHome}/sqlite_history";
      GOPATH = "${dataHome}/go";
      XDG_CONFIG_HOME = configHome;
      # PYTHONSTARTUP = "${builtins.toFile "pythonrc" ''
      #   import os
      #   import atexit
      #   import readline
      #
      #   history = '${cacheHome}/python_history'
      #   try:
      #     readline.read_history_file(history)
      #   except OSError:
      #     pass
      #
      #   def write_history():
      #     try:
      #       readline.write_history_file(history)
      #     except OSError:
      #       pass
      #
      #     atexit.register(write_history)
      # ''}";
    };
  };
}
