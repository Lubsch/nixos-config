{ config, pkgs, ... }: {
  home = {
    sessionVariables.EDITOR = "nvim";
    packages = with pkgs; [ 
      lldb
      typst-lsp
      rnix-lsp
      clang-tools
      clang
      jdt-language-server
      (import ./package.nix pkgs) ];
  };


  # Persist log, shada, swap and undo (could require manual cleanup)
  home.persistence."/persist${config.home.homeDirectory}".directories = [ 
    ".local/state/nvim" 
  ];

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
