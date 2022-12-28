{ pkgs, ... }: {
  imports = [
    ./lang-stuff.nix
  ];

  home.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;
    extraConfig = ''
      " Improve startup time
      lua require('impatient')

      "Remap leader key
      map <Space> <Leader>

      " So that neovim follows the transparency rules of alacritty
      hi Normal ctermbg=NONE guibg=NONE

      " Disable escape timeout
      set notimeout

      "RUNNING FILES AND OPENING RESULTS
      command CompileFile :AsyncRun compileFile %
      command OpenResult :silent !openResult % <cr>
      nmap <silent> <leader>k :CompileFile<cr>
      nmap <silent> <leader>l :OpenResult<cr>

      " Use CTRL-V clipboard
      set clipboard=unnamedplus

      " Enable file type detection and do language-dependent indenting.
      filetype plugin indent on

      " Switch syntax highlighting on
      syntax on

      " Make backspace behave in a sane manner.	
      set backspace=indent,eol,start

      "Ignore case when searching
      set ignorecase

      "When searching be smart about cases
      set hlsearch
      noh

      "Make search like in modern browsers
      set incsearch

      "Clear search higlighting with esc
      nnoremap <silent> <esc> :noh<CR><esc>

      "For regular expressions
      set magic

      "Persistent undo
      set undofile

      "Enable search highlighting
      set hlsearch

      "Relative line numbering
      set number relativenumber

      "Make vim not pretend to be vi
      set nocompatible

      "utf8 encoding
      set encoding=utf-8

      "INDENT
      set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent
      autocmd FileType nix setlocal tabstop=2 softtabstop=2 shiftwidth=2

      "Wrap lines
      set wrap linebreak nolist

      "4000ms by default, would lead to delays
      set updatetime=50

      "SHORTCUTS
      "Toggle spell checking
      nnoremap <leader>od :set spell spelllang=de<cr>
      nnoremap <leader>oe :set spell spelllang=en<cr>
      nnoremap <leader>oo :setlocal spell!<cr>
      "Fast saving
      nnoremap <leader>w :w<cr>
      " Go to wiki index
      nnoremap <leader>i :e $HOME/documents/wiki/index.md<cr>
      ":W doas saves file
      command! W silent execute 'w !doas tee % > /dev/null' <bar> edit!

      "Disable automatic commenting on new line
      autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

      "Leave terminal insert mode with escape
      tnoremap <Esc> <C-\><C-n>

      "Make split windows open at the bottom
      set splitbelow splitright
    '';

    plugins = with pkgs.vimPlugins; [
      vim-commentary
      asyncrun-vim
      vim-startuptime
      impatient-nvim
      {
        plugin = smartpairs-vim;
        config = "lua require 'pairs':setup(opts)";
      }
      {
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }
      {
        plugin = telescope-nvim;
        config = ''
          nnoremap <silent> <leader>f :Telescope find_files<cr>
          nnoremap <silent> <leader>b :Telescope buffers<cr>
          nnoremap <silent> <leader>g :Telescope live_grep<cr>
        '';
      }
    ];
  };

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
