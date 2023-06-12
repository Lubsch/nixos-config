# TODO install grammars without rebuild
pkgs:
with pkgs; symlinkJoin {
  name = "nvim";
  meta.mainProgram = "nvim";
  paths = [
    typst-lsp
    rnix-lsp
    clang-tools
    jdt-language-server
    (wrapNeovim neovim-unwrapped {
      configure = {
        customRC = ''
          lua << EOF
          -- install all treesitter grammars without slowing down startup
          vim.opt.runtimepath:append("${symlinkJoin {
            name = "treesitter-grammars";
            paths = vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
          } }")
          ${builtins.readFile ./init.lua}
          EOF
          ${builtins.readFile ./init.vim}
        '';
        packages.myVimPackage = with vimPlugins; {
          start = [
            nvim-cmp
            cmp-nvim-lsp
            cmp-path
            typst-vim
            nvim-treesitter
            nvim-lspconfig
            vim-commentary
            nvim-autopairs
            tex-conceal-vim
            gruvbox-nvim
            asyncrun-vim
            telescope-nvim
            telescope-fzf-native-nvim
            vim-startuptime
            impatient-nvim
            markdown-preview-nvim
          ];
          opt = [];
        };
      };
    })
  ];
}
