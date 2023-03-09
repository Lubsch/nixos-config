{ config, pkgs, colorscheme, ... }: {
  home.packages = [ (import ../pkgs/nvim { inherit pkgs colorscheme; }) ];

  # TODO reactivate this when it works instead of using environment.sessionVariables
  /* home.sessionVariables.EDITOR = "nvim"; */

  # Persist log, shada, swap and undo (could all be cleaned out from time to time but it's better to be save)
  persistence."/persist${config.home.userDirectory}".directories = [ ".local/state/nvim" ];

  xdg.desktopEntries = {
    nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "nvim %F";
      icon = "nvim";
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
      terminal = true;
      type = "Application";
      categories = [ "Utility" "TextEditor" ];
    };
  };
}
